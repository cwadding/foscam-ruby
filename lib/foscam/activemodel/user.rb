module Foscam
	module ActiveModel
		class User < Base
			
			# Max number of users supported by foscam
			MAX_NUMBER = 8

			# :nodoc
			define_model_callbacks :save, :create, :destroy
			
			##
			# @!attribute [r] id
			#   @return [Fixnum] The id of the user
			attr_reader :id

			##
			# @!attribute [rw] username
			#   @return [String] The name of the user
			attr_reader :username

			##
			# @!attribute [rw] password
			#   @return [String] The password of the user
			attr_reader :password

			##
			# @!attribute [rw] privilege
			#   @return [Symbol] The privilege of the user
			attr_reader :privilege

			define_attribute_methods [:username, :password, :privilege]


			def username=(val)
				username_will_change! unless val == @username
				@username = val
			end

			def password=(val)
				password_will_change! unless val == @password
				@password = val
			end

			def privilege=(val)
				privilege_will_change! unless val == @privilege
				@privilege = val
			end

			##
			# Get all the users
			# @return [Array] of Users
			def self.all
				cam_params = client.get_params
				users = []
				unless cam_params.empty?
					(1..8).each do |i|
						unless cam_params["user#{i}_name".to_sym].empty?
							user = User.new(:username => cam_params["user#{i}_name".to_sym], :password => cam_params["user#{i}_pwd".to_sym], :privilege => cam_params["user#{i}_pri".to_sym])
							user.instance_variable_set(:@id, i)
							users << user
						end
					end
				end
				users
			end

			##
			# Create a user with the specified parameters
			# @param params [Hash] User attributes
			# @option params [String] :username
			# @option params [String] :password
			# @option params [Symbol] :privilege
			# @return [User, nil] Returns the user if successfully saved
			def self.create(params ={})
				user = User.new(params)
				user.save ? user : nil
			end


			##
			# Find a specific user by name
			# @param id [Fixnum] The id of the user
			# @return [User]
			def self.find(id)
				user = nil
				if id > 0 && id <= MAX_NUMBER
					cam_params = client.get_params
					if !cam_params.empty? && !cam_params["user#{id}_name".to_sym].empty?
						user = User.new(:username => cam_params["user#{id}_name".to_sym], :password => cam_params["user#{id}_pwd".to_sym], :privilege => cam_params["user#{id}_pri".to_sym])
						user.instance_variable_set(:@id, id)
					end
				end
				user
			end

			##
			# Delete a user by the id
			# @param id [Fixnum] The id of the user
			# @return [FalseClass, TrueClass] Whether or not the user was successfully deleted
			def self.delete(id)
				params = {"user#{id}".to_sym => "", "pwd#{id}".to_sym => "", "pri#{id}".to_sym => 0}
				id > 0 && id <= MAX_NUMBER ? client.set_users(params) : false
			end


			##
			# Save the current user to the camera
			# @return [FalseClass, TrueClass] Whether or not the user was successfully saved
			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid? && set_id
						@previously_changed = changes
						# Get the first user that is not taken
						flag = client.set_users(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			##
			# Check for User equality
			# @param other [User]
			# @return [FalseClass, TrueClass] Whether or not the users are the same
			def ==(other)
				other.equal?(self) || ( other.instance_of?(self.class) && other.id == @id && !other.id.nil? && !@id.nil?)
			end

			##
			# Delete the current user
			# @return [FalseClass, TrueClass] Whether or not the user was successfully deleted
			def destroy
				run_callbacks :destroy do
					self.username = ""
					self.password = ""
					self.privilege = 0
					flag = @id.nil? ? false : client.set_users(dirty_params_hash)
					@changed_attributes.clear
					flag
				end
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({"user#{@id}".to_sym => @username}) if username_changed?
				h.merge!({"pwd#{@id}".to_sym => @password}) if password_changed?
				h.merge!({"pri#{@id}".to_sym => @privilege}) if privilege_changed?
				h
			end

			def set_id
				flag = false
				if @id.nil?
					cam_params = client.get_params
					unless cam_params.empty?
						(1..8).each do |i|
							if cam_params["user#{i}_name".to_sym].empty?
								@id = i
								flag = true
								break
							end
						end
					end
				else
					flag = true
				end
				flag
			end
		end
	end
end