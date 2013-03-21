		# 	* :ftp_svr  (String)
		# 	* :ftp_port  (String)
		# 	* :ftp_user  (String)
		# 	* :ftp_pwd  (String)
		# 	* :ftp_dir  (String)
		# 	* :ftp_mode  (String)
		# 	* :ftp_upload_interval  (String)
		# 	* :ftp_filename  (String)
		# 	* :ftp_numberoffiles (Fixnum)
		# 	* :ftp_schedule_enable (FalseClass, TrueClass)
		# 	* :ftp_schedule_sun_0 (Fixnum)
		# 	* :ftp_schedule_sun_1 (Fixnum)
		# 	* :ftp_schedule_sun_2 (Fixnum)
		# 	* :ftp_schedule_mon_0 (Fixnum)
		# 	* :ftp_schedule_mon_1 (Fixnum)
		# 	* :ftp_schedule_mon_2 (Fixnum)
		# 	* :ftp_schedule_tue_0 (Fixnum)
		# 	* :ftp_schedule_tue_1 (Fixnum)
		# 	* :ftp_schedule_tue_2 (Fixnum)
		# 	* :ftp_schedule_wed_0 (Fixnum)
		# 	* :ftp_schedule_wed_1 (Fixnum)
		# 	* :ftp_schedule_wed_2 (Fixnum)
		# 	* :ftp_schedule_thu_0 (Fixnum)
		# 	* :ftp_schedule_thu_1 (Fixnum)
		# 	* :ftp_schedule_thu_2 (Fixnum)
		# 	* :ftp_schedule_fri_0 (Fixnum)
		# 	* :ftp_schedule_fri_1 (Fixnum)
		# 	* :ftp_schedule_fri_2 (Fixnum)
		# 	* :ftp_schedule_sat_0 (Fixnum)
		# 	* :ftp_schedule_sat_1 (Fixnum)
		# 	* :ftp_schedule_sat_2 (Fixnum)

module Foscam
	module Model
		class FtpServer < Base

			include Singleton


			define_model_callbacks :save, :clear

			attr_reader :dir, :username, :password, :address, :port, :upload_interval


			def dir=(val)
				dir_will_change! unless val == @dir
				@dir = val
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

			def upload_interval=(val)
				upload_interval_will_change! unless val == @upload_interval
				@upload_interval = val
			end


			def client=(obj)
				unless obj.nil?
					FtpServer::client = obj
					params = client.get_params
					unless params.empty?
						self.dir = params[:ftp_dir]
						self.address = params[:ftp_svr]
						self.port = params[:ftp_port]
						self.username = params[:ftp_user]
						self.password = params[:ftp_pwd]
						self.upload_interval = params[:ftp_upload_interval]
					end
				end
			end

			define_attribute_methods [:dir, :username, :password, :address, :port, :upload_interval]

			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid?
						@previously_changed = changes
						flag = client.set_ftp(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			def clear
				run_callbacks :clear do
					flag = false
					params = {:dir => "", :user => "", :pwd => "", :svr => "", :port => 21, :upload_interval => 0}
					flag = client.set_ftp(params)
					@changed_attributes.clear if flag
					flag
				end
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({:dir => self.dir}) if dir_changed?
				h.merge!({:user => self.username}) if username_changed?
				h.merge!({:pwd => self.password}) if password_changed?
				h.merge!({:svr => self.address}) if address_changed?
				h.merge!({:port => self.port}) if port_changed?
				h.merge!({:upload_interval => self.upload_interval}) if upload_interval_changed?
				h
			end
		end
	end
end