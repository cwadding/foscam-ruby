module Foscam
	module ActiveModel
		class MailServer < Base

			include Singleton

			class Recipient

				include Singleton
				include ::ActiveModel::Dirty
				include ::ActiveModel::Validations
				include ::ActiveModel::Conversion
				extend ::ActiveModel::Naming
				extend ::ActiveModel::Translation


				attr_accessor :id

				attr_reader :address

				define_attribute_methods [:address]

				def initialize(params = nil)
					params.each do |attr, value|
						self.public_send("#{attr}=", value)
					end if params
				end

				def address=(val)
					address_will_change! unless val == @address
					@address = val
				end

			end

			define_model_callbacks :save, :clear

			attr_reader :username, :password, :address, :port, :sender, :recipients


			def sender=(val)
				sender_will_change! unless val == @sender
				@sender = val
			end

			def username=(val)
				username_will_change! unless val == @username
				@username = val
			end

			def password=(val)
				password_will_change! unless val == @password
				@password = val
			end

			def address=(val)
				address_will_change! unless val == @address
				@address = val
			end

			def port=(val)
				port_will_change! unless val == @port
				@port = val
			end

			def client=(obj)
				unless obj.nil?
					MailServer::client = obj
					params = client.get_params
					unless params.empty?
						self.sender = params[:mail_sender]
						self.address = params[:mail_svr]
						self.port = params[:mail_port]
						self.username = params[:mail_user]
						self.password = params[:mail_pwd]
						@recipients = []
						(1..4).each do |i|
							@recipients << Recipient.new(:id => i, :address => params["mail_receiver#{i}".to_sym]) if params.has_key?("mail_receiver#{i}".to_sym) && !params["mail_receiver#{i}".to_sym].empty?
						end
					end
				end
			end

			define_attribute_methods [:username, :password, :address, :port, :sender]

			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid?
						@previously_changed = changes
						flag = client.set_mail(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			def clear
				run_callbacks :clear do
					flag = false
					params = {:sender => "", :user => "", :pwd => "", :svr => "", :port => 21, :receiver1 => "", :receiver2 => "", :receiver3 => "", :receiver4 => ""}
					flag = client.set_mail(params)
					@changed_attributes.clear if flag
					flag
				end
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({:sender => self.sender}) if sender_changed?
				h.merge!({:user => self.username}) if username_changed?
				h.merge!({:pwd => self.password}) if password_changed?
				h.merge!({:svr => self.address}) if address_changed?
				h.merge!({:port => self.port}) if port_changed?
				self.recipients.each do |recipient|
					h.merge!({"receiver#{recipient.id}".to_sym => recipient.address}) if recipient.address_changed?
				end
				h
			end
		end
	end
end