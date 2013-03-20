
module Foscam
	module Model
		class Device
			include Singleton
			include ::ActiveModel::Dirty
			include ::ActiveModel::Validations
			include ::ActiveModel::Conversion
			extend ::ActiveModel::Callbacks
			extend ::ActiveModel::Naming
			extend ::ActiveModel::Translation

			define_model_callbacks :save
			define_model_callbacks :initialize, :only => [:after]

			# attr_accessor :name (get_params, set_alias)
			attr_reader :resolution, :brightness, :contrast, :orientation, :client

			def resolution=(val)
				resolution_will_change! unless val == @resolution
				@resolution = val
			end

			def brightness=(val)
				brightness_will_change! unless val == @brightness
				@brightness = val
			end

			def contrast=(val)
				contrast_will_change! unless val == @contrast
				@contrast = val
			end

			def orientation=(val)
				orientation_will_change! unless val == @orientation
				@orientation = val
			end

			def client=(obj)
				unless obj.nil?
					@client = obj
					cam_params = @client.get_camera_params
					unless cam_params.empty?
						@resolution = cam_params[:resolution]
						@brightness = cam_params[:brightness]
						@contrast = cam_params[:contrast]
						@orientation = cam_params[:flip]
						# mode
					end
				end
			end

			define_attribute_methods [:resolution, :brightness, :contrast, :orientation]


			##
			# @param params [Hash] Device attributes
			# @option params [Fixnum] :resolution
			# @option params [Fixnum] :brightness
			# @option params [Fixnum] :contrast
			# @option params [String] :orientation
			def initialize(params ={})
				# Check if it is a Hash
				# get the parameters and set them to the attributes
				run_callbacks :initialize do
					params.each do |attr, value|
						self.public_send("#{attr}=", value)
					end if params
				end
				# Check if it is a Foscam::Client
			end

			##
			# Connects to the foscam webcam
			# @param url [String] The address to your camera
			# @param username [String] username to authorize with the camera
			# @param password [String] password to authorize with the camera
			def connect(params)
				client = ::Foscam::Client.new(params) if params.has_key?(:url)
			end

			##
			# Save the current device
			# @return [FalseClass, TrueClass] Whether or not the device was successfully saved
			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid?
						@previously_changed = changes
						flag = @client.camera_control(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			##
			# Capture the current image
			# @return [nil, ::MiniMagick::Image]
			def capture
				@client.snapshot
			end

			##
			# Preform a decoder action 
			# @param value [Symbol] The desired motion action to be sent to the camera
			# @return [FalseClass,TrueClass] whether the request was successful.
			def action(value)
				# have an action map to map some subset to the foscam set
				@client.decoder_control(value)
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({:resolution => @resolution}) if resolution_changed?
				h.merge!({:brightness => @brightness}) if brightness_changed?
				h.merge!({:contrast => @contrast}) if contrast_changed?
				h.merge!({:flip => @orientation}) if orientation_changed?
				h
			end
		end
	end
end