require "foscam/constants"
module Foscam
	class Client

		# @!attribute [rw] connection
		#   @return [Faraday] The HTTP connection object to the camera		
		attr_accessor :connection

    delegate :connect, :to => :@connection

		def initialize(args = {})
		  @connection = ::Foscam::Connection.new(args)
		  @connection.connect
		end

		##
		# Obtains a snapshot of the current image
		# @return [nil, ::MiniMagick::Image]
		# @example Save a captured image
		# 	client = Foscam::Client.new(url: 'http://192.168.0.1', username: 'foobar', password: 'secret')
		# 	image = client.snapshot
		# 	unless image.nil?
		# 		image.write('image_filename.jpg')
		# 	end
		def snapshot
			response = @connection.get('snapshot.cgi')
			response.success? ? ::MiniMagick::Image.read(response.body) : nil
		end


		def videostream_url
			"#{@url}videostream.cgi?user=#{@username}&password=#{@password}"
		end
		
		##
		# Controls the pan and tilt of the camera
		# @see DECODER_CONTROLS
		# @param action [Symbol] A symbol corresponding to the desired action.
		# @return [FalseClass,TrueClass] whether the request was successful.
		def decoder_control(action)
			case action
				when Symbol || String
					action_id = DECODER_CONTROLS[action.to_sym]
				else
					action_id = action
			end
			response = @connection.get("decoder_control.cgi?command=#{action_id}")
			response.success?
		end
		
		##
		# Obtains the devices status information
		# @return [::Foscam::Model::Device] The cameras status
		def get_status
			response = @connection.get('get_status.cgi')
			params = response.success? ? parse_response(response) : {}
      params.empty? ? nil : ::Foscam::Model::Device.new(params)
		end


		##
		# Obtains the cameras parameters (orientation, resolution, contrast, brightness)
		# @see CAMERA_PARAMS_ORIENTATION
		# @see CAMERA_PARAMS_MODE
		# @see CAMERA_PARAMS_RESOLUTION
		# @return [Hash] The cameras parameters
		# 	* :flip (String) The camera orientation.
		# 	* :mode (String) The camera mode.
		# 	* :resolution (String) The camera resolution.
		# 	* :brightness (Fixnum) The camera brightness.
		# 	* :contrast (Fixnum) The camera contrast.
		def get_camera_params
			response = @connection.get('get_camera_params.cgi')
			params = response.success? ? parse_response(response) : {}
      params.empty? ? nil : ::Foscam::Model::Camera.new(params)
		end

		##
		# Sets the camera sensor parameters
		# @see CAMERA_CONTROL_MODE
		# @see CAMERA_CONTROL_ORIENTATION
		# @see CAMERA_PARAMS_RESOLUTION
		# @param [Hash] params Parameters to set
		# @option params [Symbol,String] :resolution Set to one of the keys or values in CAMERA_PARAMS_RESOLUTION
		# @option params [Fixnum] :brightness Value between 0 and 255
		# @option params [Fixnum] :contrast Value between 0 and 6
		# @option params [Symbol, Integer] :mode Value between 0 and 2 or option in CAMERA_CONTROL_MODE
		# @option params [Symbol, Integer] :flip Value between 0 and 3 or option in CAMERA_CONTROL_ORIENTATION
		# @return [FalseClass,TrueClass] whether the request was successful.
		def camera_control(params)
			params.all? do |key, value|
				# validation
				case key
				when :resolution
					case value
					when Integer
						throw "invalid parameter value" unless [8,32].include?(value)
					when String || Symbol
						throw "invalid parameter value" unless ["vga","qvga"].include?(value.to_s.downcase)
						if value.to_s.downcase == "vga"
							value = 32
						elsif value.to_s.downcase == "qvga"
							value = 8
						end
					else
						throw "invalid parameter value type"
					end	
				when :brightness
					throw "invalid parameter value" if value.to_i < 0 || value.to_i > 255
				when :contrast
					throw "invalid parameter value" if value.to_i < 0 || value.to_i > 6
				when :mode
					case value
					when Integer
						throw "invalid parameter value" if value.to_i < 0 || value.to_i > 2
					when Symbol || String
						throw "invalid parameter value" unless ::Foscam::Model::Camera::CAMERA_CONTROL_MODE.keys.include?(value.to_s.downcase.to_sym)
						value = ::Foscam::Model::Camera::CAMERA_CONTROL_MODE[value.to_s.downcase.to_sym]
					else
						throw "invalid parameter value type"
					end
				when :flip
					case value
					when Integer
						throw "invalid parameter value" if value.to_i < 0 || value.to_i > 3
					when String || Symbol
						throw "invalid parameter value" unless ::Foscam::Model::Camera::CAMERA_CONTROL_ORIENTATION.keys.include?(value.to_s.downcase.to_sym)
						value = ::Foscam::Model::Camera::CAMERA_CONTROL_ORIENTATION[value.to_s.downcase.to_sym]
					else
						throw "invalid parameter value type"
					end
				else
					throw "invalid parameter"
				end
					
				response = @connection.get("camera_control.cgi?param=#{::Foscam::Model::Camera::CAMERA_CONTROLS[key.to_sym]}&value=#{value}")
				response.success?
			end
		end

		##
		# Reboots the camera
		# @return [FalseClass,TrueClass] whether the request was successful.
		def reboot
			response = @connection.get("reboot.cgi")
			response.success?
		end

		##
		# Restore settings to the factory defaults
		# @return [FalseClass,TrueClass] whether the request was successful.
		def restore_factory
			response = @connection.get("restore_factory.cgi")
			response.success?
		end

		##
		# Returns all the parameters for the camera
		# @return [Hash] If the request is unsuccessful the hash will be empty. Otherwise it contains the following fields:
		# 	* :id (String) The device id.
		# 	* :sys_ver (String) Firmware version number.
		# 	* :app_ver (String) Web UI version number.
		# 	* :alias (String) The assigned camera name.
		# 	* :now (DateTime) The camera's time.
		# 	* :tz (String) The camera time zone.
		# 	* :ntp_enable (FalseClass, TrueClass) Whether the ntp server is enabled.
		# 	* :ntp_svr (String) Address to the ntp server.
		# 	* :user1_name (String) Username of user1.
		# 	* :user1_pwd (String) Password of user1.
		# 	* :user1_pri (String) Privilages of user1.
		# 	* ...
		# 	* :user8_name (String) Username of user8.
		# 	* :user8_pwd (String) Password of user8.
		# 	* :user8_pri (String) Privilages of user8.
		# 	* :dev2_alias (String) The 2nd Device alias 
		# 	* :dev2_host (String) The 2nd Device host(IP or Domain name) 
		# 	* :dev2_port (String) The 2nd Device port.
		# 	* :dev2_user (String) The 2nd Device user name .
		# 	* :dev2_pwd (String) The 2nd Device password.
		# 	* ...
		# 	* :dev9_alias (String) The 9th Device alias 
		# 	* :dev9_host (String) The 9th Device host(IP or Domain name) 
		# 	* :dev9_port (Fixnum) The 9th Device port.
		# 	* :dev9_user (String) The 9th Device user name .
		# 	* :dev9_pwd (String) The 9th Device password.
		# 	* :ip_address (String) The network ip address of the camera.
		# 	* :mask (String) The network mask of the camera.
		# 	* :gateway (String) The network gateway of the camera.
		# 	* :dns (String) The address of the dns server.
		# 	* :port (Fixnum) The network port.
		# 	* :wifi_enable (FalseClass, TrueClass) Whether wifi is enabled or not.
		# 	* :wifi_ssid (String) Your WIFI SSID 
		# 	* :wifi_encrypt (FalseClass, TrueClass) Whether wifi is encrypted or not.
		# 	* :wifi_defkey (String) Wep Default TX Key 
		# 	* :wifi_key1 (String) Key1 
		# 	* :wifi_key2 (String) Key2 
		# 	* :wifi_key3 (String) Key3 
		# 	* :wifi_key4 (String) Key4 
		# 	* :wifi_autht (String) ype The Authetication type 0:open 1:share
		# 	* :wifi_keyfo (String) rmat Keyformat 0:Hex 1:ASCII 
		# 	* :wifi_key1_bits (String) 0:64 bits; 1:128 bits 
		# 	* :wifi_key2_bits (String) 0:64 bits; 1:128 bits 
		# 	* :wifi_key3_bits (String) 0:64 bits; 1:128 bits 
		# 	* :wifi_key4_bits (String) 0:64 bits; 1:128 bits 
		# 	* :wifi_channel (String) Channel (default 6) 
		# 	* :wifi_mode (String) Mode (default 0) 
		# 	* :wifi_wpa_psk (String) wpa_psk
		# 	* :pppoe_enable (FalseClass, TrueClass)
		# 	* :pppoe_user (String)
		# 	* :pppoe_pwd (String)
		# 	* :upnp_enable (FalseClass, TrueClass)
		# 	* :ddns_service (String)
		# 	* :ddns_user (String)
		# 	* :ddns_pwd (String)
		# 	* :ddns_host (String)
		# 	* :ddns_proxy_svr (String)
		# 	* :ddns_proxy_port (Fixnum)
		# 	* :mail_svr (String)
		# 	* :mail_port  (Fixnum)
		# 	* :mail_tls (String)
		# 	* :mail_user (String)
		# 	* :mail_pwd (String)
		# 	* :mail_sender (String)
		# 	* :mail_receiver1 (String)
		# 	* :mail_receiver2 (String)
		# 	* :mail_receiver3 (String)
		# 	* :mail_receiver4 (String)
		# 	* :mail_inet_ip (String)
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
		# 	* :ftp_schedule (Schedule::Week)
		# 	* :alarm_motion_armed (FalseClass, TrueClass)
		# 	* :alarm_motion_sensitivity (Fixnum)
		# 	* :alarm_motion_compensation  (Fixnum)
		# 	* :alarm_input_armed  (FalseClass, TrueClass]
		# 	* :alarm_ioin_level  (Fixnum)
		# 	* :alarm_iolinkage  (Fixnum)
		# 	* :alarm_preset  (Fixnum)
		# 	* :alarm_ioout_level  (Fixnum)
		# 	* :alarm_mail (FalseClass, TrueClass)
		# 	* :alarm_upload_interval (Fixnum)
		# 	* :alarm_http (FalseClass, TrueClass)
		# 	* :alarm_msn (FalseClass, TrueClass)
		# 	* :alarm_http_url (String)
		# 	* :alarm_schedule_enable (FalseClass, TrueClass)
		# 	* :alarm_schedule (Schedule::Week)
		# 	* :decoder_baud (Fixnum)
		# 	* :msn_user (String)
		# 	* :msn_pwd (String)
		# 	* :msn_friend1 (String)
		# 	* :msn_friend2 (String)
		# 	* :msn_friend3 (String)
		# 	* :msn_friend4 (String)
		# 	* :msn_friend5 (String)
		# 	* :msn_friend6 (String)
		# 	* :msn_friend7 (String)
		# 	* :msn_friend8 (String)
		# 	* :msn_friend9 (String)
		# 	* :msn_friend10 (String) 
		def get_params
			response = @connection.get("get_params.cgi")
			params = response.success? ? parse_response(response) : {}
      
			result = {}
      unless params.empty?
        result = Client.group_params(params)
        result[:device] = ::Foscam::Model::Device.new( result[:device] )
        result[:ntp] = ::Foscam::Model::NtpServer.new( result[:ntp] )
        result[:ddns] = ::Foscam::Model::Ddns.new( result[:ddns] )
        result[:network] = ::Foscam::Model::Network.new( result[:network] )
        result[:mail] = ::Foscam::Model::MailServer.new( result[:mail] )
        result[:wifi] = ::Foscam::Model::WifiConfig.new( result[:wifi] )
        result[:ftp] = ::Foscam::Model::FtpServer.new( result[:ftp] )
        result[:alarm] = ::Foscam::Model::AlarmConfig.new( result[:alarm] )
        result[:msn] = ::Foscam::Model::Msn.new( result[:msn] )
        users = []
        result[:users].each do |id, user|
          user.merge!(:id => id)
          users << ::Foscam::Model::User.new(user)
        end
        result[:users] = users
        
        # :pppoe
        # :upnp
        # :ddns
        # :decoder


			     # 
			     #   [:daylight_savings_time, :ddns_proxy_port, :ftp_port, :mail_port, :port, :dev2_port, :dev3_port, :dev4_port, :dev5_port, :dev6_port, :dev7_port, :dev8_port, :dev9_port].each do |field|
			     #     response[field] = response[field].to_i
			     #   end
			     #   response[:users] = {}
			     # 
			     #         # Device
			     # 
			     #         # Users
			     #   ::Foscam::Model::User::MAX_NUMBER.times do |i|
			     #     unless response.has_key?("user#{i}_name") && response["user#{i+1}_name"].empty?
			     #       response[:users] << ::Foscam::Model::User.new({:id => i+1, :username => response["user#{i+1}_name"], :password => response["user#{i+1}_pwd"], :privilage => response["user#{i+1}_pri"]})
			     #     end
			     #   end
			  
        # Network
        # ::Foscam::Model::Network.new(extract_network_parameters(response))
        # Wifi
			  
        # MSN
        
        # Alarm Config
        
        # Ftp server
        
        # Mail server
			  
      end
      result
		end

		##
		# Upgrade the camera firmware
		# @return [FalseClass,TrueClass] whether the request was successful.
		def upgrade_firmware
			response = @connection.post("upgrade_firmware.cgi")
		end

		##
		# Upgrade the cameras html pages.
		# @return [FalseClass,TrueClass] whether the request was successful.
		def upgrade_htmls
			response = @connection.post("upgrade_htmls.cgi")
		end


		##
		# Set the name of the camera
		# @param [String] name The name of the camera which is 20 characters or less.
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_alias(name)
			throw "invalid parameter value" if name.length > 20
			response = @connection.get("set_alias.cgi?alias=#{name}")
			response.success?
		end

		##
		# Set the datetime of the camera
		# @param [Hash] params
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_datetime(params)
			# Extract the time zone
			throw "invalid parameter value" if params.has_key?(:ntp_svr) && params[:ntp_svr].length > 64
			response = @connection.get("set_datetime.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Set usernames, passwords and privilages
		# @param [Hash] params
		# @option params [String] :user1 Username of user1.
		# @option params [String] :pwd1 Password of user1.
		# @option params [String] :pri1 Privilages of user1.
		# @option params [String] ...
		# @option params [String] :user8 Username of user8.
		# @option params [String] :pwd8 Password of user8.
		# @option params [String] :pri8 Privilages of user8.
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_users(params)
			[:user1, :pwd1, :user2, :pwd2, :user3, :pwd3, :user4, :pwd4, :user5, :pwd5, :user6, :pwd6, :user7, :pwd7, :user8, :pwd8].each do |key|
				throw "invalid parameter value" if params.has_key?(key) && params[key].length > 12
			end
			# if it is one of the matching symbols then set it to the corresponding integer
			[:pri1, :pri2, :pri3, :pri4, :pri5, :pri6, :pri7, :pri8].each do |key|
				params[key] = USER_PERMISSIONS_ID[key] if params.has_key?(key) && params[key].is_a?(Symbol)
			end

			response = @connection.get("set_users.cgi?#{params.to_query}")
			response.success?
		end

		# def set_devices(params)
		# 	response = @connection.get("set_devices.cgi?#{params.to_query}")
		# end

		##
		# Set usernames, passwords and privilages
		# @param [Hash] params
		# @option params [String] :ip  if ip set to "",The device will DHCP Ip
		# @option params [String] :mask mask
		# @option params [String] :gateway gateway
		# @option params [String] :dns dns server
		# @option params [Fixnum] :port port number
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_network(params)
			response = @connection.get("set_network.cgi?#{params.to_query}")
			response.success?
		end
		##
		# Set the wifi parameters
		# @param [Hash] params
		# @option params [FalseClass, TrueClass] :enable Whether wifi is enabled or not.
		# @option params [String] :ssid Your WIFI SSID 
		# @option params [FalseClass, TrueClass] :encrypt Whether wifi is encrypted or not.
		# @option params [String] :wpa_psk wpa_psk
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_wifi(params)
			response = @connection.get("set_wifi.cgi?#{params.to_query}")
			response.success?
		end
		
		##
		# Set the pppoe parameters
		# @param [Hash] params
		# @option params [FalseClass, TrueClass] :enable 
		# @option params [String] :user 
		# @option params [String] :pwd 
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_pppoe(params)
			throw "invalid parameter value" if params.has_key?(:user) && params[:user].length > 20
			throw "invalid parameter value" if params.has_key?(:pwd) && params[:pwd].length > 20
			response = @connection.get("set_pppoe.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Enable or disable upnp
		# @param [FalseClass, TrueClass] flag A boolean for whether to enable or disable upnp.
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_upnp(flag)
			response = @connection.get("set_upnp.cgi?enable=#{handle_boolean(flag)}")
			response.success?
		end


		##
		# Set the ddns parameters
		# @param [Hash] params
		# @option params [String] :user
		# @option params [String] :pwd
		# @option params [String] :host
		# @option params [String] :service
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_ddns(params)
			throw "invalid parameter value" if params.has_key?(:user) && params[:user].length > 20
			throw "invalid parameter value" if params.has_key?(:pwd) && params[:pwd].length > 20
			throw "invalid parameter value" if params.has_key?(:host) && params[:host].length > 40
			response = @connection.get("set_ddns.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Set the ftp parameters
		# @param [Hash] params
		# @option params [String] :dir
		# @option params [String] :user
		# @option params [String] :pwd
		# @option params [String] :svr
		# @option params [Fixnum] :port
		# @option params [Fixnum] :upload_interval in seconds
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_ftp(params)
			response = @connection.get("set_ftp.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Set the smtp server mail notification parameters
		# @param [Hash] params
		# @option params [String] :user must be less than 20 characters
		# @option params [String] :pwd must be less than 20 characters
		# @option params [String] :svr
		# @option params [Fixnum] :port
		# @option params [String] :sender must be less than 40 characters
		# @option params [String] :receiver1 must be less than 40 characters
		# @option params [String] :receiver2 must be less than 40 characters
		# @option params [String] :receiver3 must be less than 40 characters
		# @option params [String] :receiver4 must be less than 40 characters
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_mail(params)
			throw "invalid parameter value" if params.has_key?(:user) && params[:user].length > 20
			throw "invalid parameter value" if params.has_key?(:pwd) && params[:pwd].length > 20
			[:sender, :receiver1, :receiver2, :receiver3, :receiver4].each do |key|
				throw "invalid parameter value" if params.has_key?(key) && params[key].length > 40
			end
			response = @connection.get("set_mail.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Set alarm parameters
		# @param [Hash] params
		# @option params [TrueClass, FalseClass] :motion_armed Whether the motion is enabled or disabled
		# @option params [TrueClass, FalseClass] :input_armed Whether the motion is enabled or disabled
		# @option params [TrueClass, FalseClass] :mail whether to send email on alarm
		# @option params [TrueClass, FalseClass] :iolinkage whether to send email on alarm        
		# @option params [Fixnum] :motion_sensitivity 
		# @option params [Fixnum] :upload_interval in seconds
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_alarm(params)
			response = @connection.get("set_alarm.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Write to comm
		# @param [Hash] params
		# @option params [Fixnum] :baud
		# @option params [String] :bytes
		# @option params [String] :data
		# @option params [Fixnum] :port
		# @return [FalseClass,TrueClass] whether the request was successful.
		def comm_write(params)
			response = @connection.get("comm_write.cgi?#{params.to_query}")
			response.success?
		end

		##
		# Set Forbidden
		# @param [Schedule::Week] week
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_forbidden(week)
			if week.is_a?(Schedule::Week)
				params = {}
				week.to_param.each_pair do |key, value|
					params.merge!("schedule_#{key}" => value)
				end
				response = @connection.get("set_forbidden.cgi?#{params.to_query}")
				response.success?
			else
				false
			end
		end

		##
		# Returns the forbidden schedule for the camera
		# @return [Schedule::Week, nil] If the request is unsuccessful then nil is returned.
		def get_forbidden
			response = @connection.get("get_forbidden.cgi")
			params = response.success? ? parse_response(response) : {}
			schedule = {}
			unless params.empty?
				params.keys.each do |field|
					match = field.to_s.match(/schedule_(.+)_(\d)/)
					unless match.nil?
						schedule.merge!("#{match[1]}_#{match[2]}".to_sym => params[field].to_i)
					end
				end
				::Foscam::Schedule::Week.new(schedule)
			else
				nil
			end
		end

		##
		# Set miscellaneous parameters 
		# @param [Hash] params
		# @option params [Fixnum] :led_mode
		# @option params [Fixnum] :ptz_auto_patrol_interval
		# @option params [Fixnum] :ptz_auto_patrol_type
		# @option params [Fixnum] :ptz_patrol_down_rate
		# @option params [Fixnum] :ptz_patrol_h_rounds
		# @option params [Fixnum] :ptz_patrol_left_rate
		# @option params [Fixnum] :ptz_patrol_rate
		# @option params [Fixnum] :ptz_patrol_right_rate
		# @option params [Fixnum] :ptz_patrol_up_rate
		# @option params [Fixnum] :ptz_patrol_v_rounds
		# @option params [FalseClass,TrueClass] :ptz_preset_onstart
		# @option params [FalseClass,TrueClass] :ptz_center_onstart
		# @option params [FalseClass,TrueClass] :ptz_disable_preset
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_misc(params)
			url_params = params.clone
			[:ptz_patrol_rate, :ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate].each do |key|
				throw "invalid parameter value" if (url_params.has_key?(key) && (url_params[key].to_i < 0 || url_params[key].to_i > 100))
			end
			[:ptz_auto_patrol_interval, :ptz_patrol_h_rounds, :ptz_patrol_v_rounds].each do |key|
				throw "invalid parameter value" if url_params.has_key?(key) && url_params[key].to_i < 0 
			end
			[:ptz_disable_preset, :ptz_preset_onstart, :ptz_center_onstart].each do |key|
				url_params[key] = handle_boolean(url_params[key]) if url_params.has_key?(key)
			end
			url_params[:led_mode] = LED_MODE_ID[url_params[:led_mode]] if url_params[:led_mode].is_a?(String) || url_params[:led_mode].is_a?(Symbol)
			url_params[:ptz_auto_patrol_type] = PTZ_AUTO_PATROL_TYPE_ID[url_params[:ptz_auto_patrol_type]] if url_params[:ptz_auto_patrol_type].is_a?(String) || url_params[:ptz_auto_patrol_type].is_a?(Symbol)
			response = @connection.get("set_misc.cgi?#{url_params.to_query}")
			response.success?
		end


		##
		# Get miscellaneous parameters
		# @return [Hash] If the request is unsuccessful the hash will be empty. Otherwise it contains the following fields:
		# 	* :led_mode (Fixnum)
		# 	* :ptz_auto_patrol_interval (Fixnum)
		# 	* :ptz_auto_patrol_type (Fixnum)
		# 	* :ptz_patrol_down_rate (Fixnum)
		# 	* :ptz_patrol_h_rounds (Fixnum)
		# 	* :ptz_patrol_left_rate (Fixnum)
		# 	* :ptz_patrol_rate (Fixnum)
		# 	* :ptz_patrol_right_rate (Fixnum)
		# 	* :ptz_patrol_up_rate (Fixnum)
		# 	* :ptz_patrol_v_rounds (Fixnum)
		# 	* :ptz_preset_onstart (FalseClass,TrueClass)
		# 	* :ptz_center_onstart (FalseClass,TrueClass)
		# 	* :ptz_disable_preset (FalseClass,TrueClass)
		def get_misc
			response = @connection.get("get_misc.cgi")
			response = response.success? ? parse_response(response) : {}
			unless response.empty?
				[:ptz_disable_preset, :ptz_preset_onstart, :ptz_center_onstart].each do |field|
					response[field] = response[field].to_i > 0
				end
				[:ptz_auto_patrol_interval, :ptz_patrol_h_rounds, :ptz_patrol_v_rounds, :ptz_patrol_rate, :ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate].each do |field|
					response[field] = response[field].to_i
				end
				response[:led_mode] = LED_MODE[response[:led_mode].to_i]
				response[:ptz_auto_patrol_type] = PTZ_AUTO_PATROL_TYPE[response[:ptz_auto_patrol_type].to_i]
				response
			end
			response
		end


		##
		# Set decoder baud 
		# @param [String,Symbol] baud
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_decoder(baud)
			baud = DECODER_BAUD_ID[baud.to_sym] if baud.is_a?(String) || baud.is_a?(Symbol)
			response = @connection.get("set_decoder.cgi?baud=#{baud}")
			response.success?
		end

		private

		def parse_response(response)
			response.body.scan(/var (\w+)=([^;]+);[\s+]?/).inject({}) do | params, pair |
				params.merge(pair.first.to_sym => pair.last.gsub(/'/, ''))
			end
		end

    def self.group_params(params = {})
      grouped_params = {}
      params.each do |field, value|
        
        next if segment_from_hash(field.to_s, value, /ntp_(.+)/, :ntp, grouped_params)
        next if segment_from_hash(field.to_s, value, /user(\d)_(.+)/, :users, grouped_params) do |matches, val, h|
          h.has_key?(matches[1]) ? h[matches[1]].merge!(matches[2].to_sym => val) : h.merge!({matches[1] => {matches[2].to_sym => val}})
          h
        end
        next if segment_from_hash(field.to_s, value, /wifi_(.+)/, :wifi, grouped_params)
        next if segment_from_hash(field.to_s, value, /pppoe_(.+)/, :pppoe, grouped_params)
        next if segment_from_hash(field.to_s, value, /upnp_(.+)/, :upnp, grouped_params)
        next if segment_from_hash(field.to_s, value, /ddns_(.+)/, :ddns, grouped_params)
        next if segment_from_hash(field.to_s, value, /mail_(.+)/, :mail, grouped_params)
        next if segment_from_hash(field.to_s, value, /decoder_(.+)/, :decoder, grouped_params)
        next if segment_from_hash(field.to_s, value, /msn_(.+)/, :msn, grouped_params)
        
        next if segment_from_hash(field.to_s, value, /alarm_(.+)/, :alarm, grouped_params) do |matches, val, h|
          h.merge!(matches.to_a[1..matches.size].join("_").to_sym => val) unless segment_from_hash(matches.to_a[1..matches.size].join("_").to_s, val, /schedule_(.+)/, :schedule, h)
          h
        end
        
        next if segment_from_hash(field.to_s, value, /ftp_(.+)/, :ftp, grouped_params) do |matches, val, h|
          h.merge!(matches.to_a[1..matches.size].join("_").to_sym => val) unless segment_from_hash(matches.to_a[1..matches.size].join("_").to_s, val, /schedule_(.+)/, :schedule, h)
          h
        end
        
        next if segment_from_hash(field.to_s, value, /(ip|mask|gateway|dns|port)/, :network, grouped_params)
        next if segment_from_hash(field.to_s, value, /(id|sys_ver|app_ver|alias|now|tz|daylight_saving_time)/, :device, grouped_params)
        

      end
      grouped_params
    end
    
    
    def self.segment_from_hash(str, value, regexp, new_key, dst = {}, &block)
      # throw TypeError, "Argument 1 [str] is a #{str.class.to_s}. Expected a String." unless str.is_a?(String)
      # throw TypeError, "Argument 3 [regexp] is a #{regexp.class.to_s}. Expected a Regexp/" unless regexp.is_a?(Regexp)
      # throw TypeError, "Argument 4 [new_key] is a #{new_key.class.to_s}. Expected a String or Symbol." unless new_key.is_a?(String) || new_key.is_a?(Symbol)
      # throw TypeError, "Argument 5 [dst] is a #{dst.class.to_s}. Expected a Hash" unless dst.is_a?(Hash)  
      matches = str.match(regexp)
      unless matches.nil?
        if block_given?
          dst.has_key?(new_key) ? dst[new_key].merge!(block.call(matches, value, dst[new_key])) : dst.merge!(new_key => block.call(matches, value, {}))
        elsif matches.size > 1
          dst.has_key?(new_key) ? dst[new_key].merge!(matches.to_a[1..matches.size].join("_").to_sym => value) : dst.merge!(new_key => {matches.to_a[1..matches.size].join("_").to_sym => value})
        else
          dst.has_key?(new_key) ? dst[new_key].merge!(str.to_sym => value) : dst.merge!(new_key => {str.to_sym => value})
        end
        dst[new_key]
      else
        nil
      end
    end

		def handle_boolean(flag)
			flag ? 1 : 0
		end

	end
end