module Foscam

	DDNS_STATUS = {
		0 => "No Action",
		1 => "It's connecting...",
		2 => "Can't connect to the Server",
		3 => "Dyndns Succeed",
		4 => "DynDns Failed: Dyndns.org Server Error",
		5 => "DynDns Failed: Incorrect User or Password",
		6 => "DynDns Failed: Need Credited User",
		7 => "DynDns Failed: Illegal Host Format",
		8 => "DynDns Failed: The Host Does not Exist",
		9 => "DynDns Failed: The Host Does not Belong to You",
		10 => "DynDns Failed: Too Many or Too Few Hosts",
		11 => "DynDns Failed: The Host is Blocked for Abusing",
		12 => "DynDns Failed: Bad Reply from Server",
		13 => "DynDns Failed: Bad Reply from Server",
		14 => "Oray Failed: Bad Reply from Server",
		15 => "Oray Failed: Incorrect User or Password",
		16 => "Oray Failed: Incorrect Hostname",
		17 => "Oray Succeed"
	}

	UPNP_STATUS = {
		0 => "No Action",
		1 => "Succeed",
		2 => "Device System Error",
		3 => "Errors in Network Communication",
		4 => "Errors in Chat with UPnP Device",
		5 => "Rejected by UPnP Device, Maybe Port Conflict"
	}

	ALARM_STATUS = {
		0 => "No alarm",
		1 => "Motion alarm",
		2 => "Input Alarm"
	}

	CAMERA_PARAMS_MODE = {
		0 => "50hz",
		1 => "60hz",
		2 => "outdoor"
	}
	CAMERA_CONTROL_MODE = CAMERA_PARAMS_MODE.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	CAMERA_PARAMS_ORIENTATION = {
		0 => "default",
		1 => "flip",
		2 => "mirror",
		3 => "flip+mirror"
	}

	CAMERA_CONTROL_ORIENTATION = CAMERA_PARAMS_ORIENTATION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	CAMERA_PARAMS_RESOLUTION = {
		8 => "qvga",
		32 => "vga"
	}

	CAMERA_CONTROL_RESOLUTION = CAMERA_PARAMS_RESOLUTION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	CAMERA_CONTROLS = {
		:resolution => 0,
		:brightness => 1,
		:contrast 	=> 2,
		:mode 		=> 3,
		:flip 		=> 5
	}

	DECODER_CONTROLS = {
		:up  => 0,
		:stop => 1,
		:stop_up => 1,
		:down => 2,
		:stop_down => 3,
		:left => 4,
		:stop_left => 5,
		:right => 6,
		:stop_right => 7,
		:center => 25,
		:vertical_patrol => 26,
		:stop_vertical_patrol => 27,
		:horizon_patrol => 28,
		:stop_horizon_patrol => 29,
		:io_output_high => 94,
		:io_output_low => 95,
	}

	USER_PERMISSIONS = {
		0 => :visitor,
		1 => :operator,
		2 => :administrator
	}

	PTZ_AUTO_PATROL_TYPE = {
		0 => :none,
		1 => :horizontal,
		2 => :vertical,
		3 => :"horizontal+vertical"
	}
	PTZ_AUTO_PATROL_TYPE_ID = PTZ_AUTO_PATROL_TYPE.invert

	LED_MODE = {
		0 => :mode1,
		1 => :mode2,
		2 => :disabled
	}
	LED_MODE_ID = LED_MODE.invert
	DECODER_BAUD = {
		9 => :B1200,
		11 => :B2400,
		12 => :B4800,
		13 => :B9600,
		14 => :B19200,
		15 => :B38400,
		4097 => :B57600,
		4098 => :B115200
	}

	DECODER_BAUD_ID = DECODER_BAUD.invert


	class Client

		attr_accessor :url, :username, :password, :connection

		def initialize(args = {})
			@url = args.delete(:url)
			@username = args.delete(:username)
			@password = args.delete(:password)
			connect(@url, @username, @password)
		end

		##
		# Connects to the foscam webcam

		# @param url [String] The address to your camera
		# @param username [String] username to authorize with the camera
		# @param password [String] password to authorize with the camera
		# @example connect to a camera
		# 	client = Foscam::Client.new
		# 	client.connect('http://192.168.0.1', 'foobar', 'secret')
		def connect(url, username = nil, password = nil)
			@url = url
			@username = username
			@password = password
			@connection = Faraday.new( :url => @url) unless @url.nil?
			@connection.basic_auth(@username, @password) unless @username.nil? && @password.nil?
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

		##
		# Obtains the cameras status information
		# @see DDNS_STATUS
		# @see UPNP_STATUS
		# @see ALARM_STATUS
		# @return [Hash] The cameras status
		# 	* :now [DateTime] The current time on the camera
		# 	* :alarm_status [String] Returns an Alarm status
		# 	* :ddns_status [String] Returns an UPNP status
		# 	* :upnp_status [String] Returns an DDNS status
		def get_status
			response = @connection.get('get_status.cgi')
			response = response.success? ? parse_response(response) : {}
			unless response.empty?
				response[:ddns_status] = DDNS_STATUS[response[:ddns_status].to_i]
				response[:upnp_status] = UPNP_STATUS[response[:upnp_status].to_i]
				response[:alarm_status] = ALARM_STATUS[response[:alarm_status].to_i]
				response[:now] = DateTime.strptime(response[:now],'%s')
			end
			response
		end


		##
		# Obtains the cameras parameters (orientation, resolution, contrast, brightness)
		# @see CAMERA_PARAMS_ORIENTATION
		# @see CAMERA_PARAMS_MODE
		# @see CAMERA_PARAMS_RESOLUTION
		# @return [Hash] The cameras parameters
		# 	* :flip [String] The camera orientation.
		# 	* :mode [String] The camera mode.
		# 	* :resolution [String] The camera resolution.
		# 	* :brightness [Fixnum] The camera brightness.
		# 	* :contrast [Fixnum] The camera contrast.
		def get_camera_params
			response = @connection.get('get_camera_params.cgi')
			response = response.success? ? parse_response(response) : {}
			unless response.empty?
				response[:flip] = CAMERA_PARAMS_ORIENTATION[response[:flip].to_i]
				response[:mode] = CAMERA_PARAMS_MODE[response[:mode].to_i]
				response[:resolution] = CAMERA_PARAMS_RESOLUTION[response[:resolution].to_i]
				[:brightness, :contrast].each {|field| response[field] = response[field].to_i}
			end
			response
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
						throw "invalid parameter value" unless CAMERA_CONTROL_MODE.keys.include?(value.to_s.downcase.to_sym)
						value = CAMERA_CONTROL_MODE[value.to_s.downcase.to_sym]
					else
						throw "invalid parameter value type"
					end
				when :flip
					case value
					when Integer
						throw "invalid parameter value" if value.to_i < 0 || value.to_i > 3
					when String || Symbol
						throw "invalid parameter value" unless CAMERA_CONTROL_ORIENTATION.keys.include?(value.to_s.downcase.to_sym)
						value = CAMERA_CONTROL_ORIENTATION[value.to_s.downcase.to_sym]
					else
						throw "invalid parameter value type"
					end
				else
					throw "invalid parameter"
				end
					
				response = @connection.get("camera_control.cgi?param=#{CAMERA_CONTROLS[key.to_sym]}&value=#{value}")
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
		# 	* [String] :id The device id.
		# 	* [String] :sys_ver Firmware version number.
		# 	* [String] :resolution Web UI version number.
		# 	* [String] :alias The assigned camera name.
		# 	* [DateTime] :now The camera's time.
		# 	* [String] :tz The camera time zone.
		# 	* [FalseClass, TrueClass] :ntp_enable Whether the ntp server is enabled.
		# 	* [String] :ntp_svr Address to the ntp server.
		# 	* [String] :user1_name Username of user1.
		# 	* [String] :user1_pwd Password of user1.
		# 	* [String] :user1_pri Privilages of user1.
		# 	* ...
		# 	* [String] :user8_name Username of user8.
		# 	* [String] :user8_pwd Password of user8.
		# 	* [String] :user8_pri Privilages of user8.
		# 	* [String] :dev2_alias] The 2nd Device alias 
		# 	* [String] :dev2_host The 2nd Device host(IP or Domain name) 
		# 	* [String] :dev2_port The 2nd Device port.
		# 	* [String] :dev2_user The 2nd Device user name .
		# 	* [String] :dev2_pwd The 2nd Device password.
		# 	* ...
		# 	* [String] :dev9_alias The 9th Device alias 
		# 	* [String] :dev9_host The 9th Device host(IP or Domain name) 
		# 	* [Fixnum] :dev9_port The 9th Device port.
		# 	* [String] :dev9_user The 9th Device user name .
		# 	* [String] :dev9_pwd The 9th Device password.
		# 	* [String] :ip_address The network ip address of the camera.
		# 	* [String] :mask The network mask of the camera.
		# 	* [String] :gateway The network gateway of the camera.
		# 	* [String] :dns The address of the dns server.
		# 	* [Fixnum] :port The network port.
		# 	* [FalseClass, TrueClass] :wifi_enable Whether wifi is enabled or not.
		# 	* [String] :wifi_ssid Your WIFI SSID 
		# 	* [FalseClass, TrueClass] :wifi_encrypt Whether wifi is encrypted or not.
		# 	* [String] :wifi_defkey Wep Default TX Key 
		# 	* [String] :wifi_key1 Key1 
		# 	* [String] :wifi_key2 Key2 
		# 	* [String] :wifi_key3 Key3 
		# 	* [String] :wifi_key4 Key4 
		# 	* [String] :wifi_authtype The Authetication type 0:open 1:share
		# 	* [String] :wifi_keyformat Keyformat 0:Hex 1:ASCII 
		# 	* [String] :wifi_key1_bits 0:64 bits; 1:128 bits 
		# 	* [String] :wifi_key2_bits 0:64 bits; 1:128 bits 
		# 	* [String] :wifi_key3_bits 0:64 bits; 1:128 bits 
		# 	* [String] :wifi_key4_bits 0:64 bits; 1:128 bits 
		# 	* [String] :wifi_channel Channel (default 6) 
		# 	* [String] :wifi_mode Mode (default 0) 
		# 	* [String] :wifi_wpa_psk wpa_psk
		# 	* [FalseClass, TrueClass] :pppoe_enable 
        # 	* [String] :pppoe_user
        # 	* [String] :pppoe_pwd
        # 	* [FalseClass, TrueClass] :upnp_enable
        # 	* [String] :ddns_service
        # 	* [String] :ddns_user
        # 	* [String] :ddns_pwd
        # 	* [String] :ddns_host
        # 	* [String] :ddns_proxy_svr
        # 	* [Fixnum] :ddns_proxy_port
        # 	* [String] :mail_svr
        # 	* [Fixnum] :mail_port 
        # 	* [String] :mail_tls
        # 	* [String] :mail_user
        # 	* [String] :mail_pwd
        # 	* [String] :mail_sender
        # 	* [String] :mail_receiver1
        # 	* [String] :mail_receiver2
        # 	* [String] :mail_receiver3
        # 	* [String] :mail_receiver4
        # 	* [String] :mail_inet_ip
        # 	* [String] :ftp_svr 
        # 	* [String] :ftp_port 
        # 	* [String] :ftp_user 
        # 	* [String] :ftp_pwd 
        # 	* [String] :ftp_dir 
        # 	* [String] :ftp_mode 
        # 	* [String] :ftp_upload_interval 
        # 	* [String] :ftp_filename 
        # 	* [Fixnum] :ftp_numberoffiles
        # 	* [FalseClass, TrueClass] :ftp_schedule_enable 
        # 	* [Fixnum] :ftp_schedule_sun_0 
        # 	* [Fixnum] :ftp_schedule_sun_1 
        # 	* [Fixnum] :ftp_schedule_sun_2 
        # 	* [Fixnum] :ftp_schedule_mon_0 
        # 	* [Fixnum] :ftp_schedule_mon_1 
        # 	* [Fixnum] :ftp_schedule_mon_2 
        # 	* [Fixnum] :ftp_schedule_tue_0 
        # 	* [Fixnum] :ftp_schedule_tue_1 
        # 	* [Fixnum] :ftp_schedule_tue_2 
        # 	* [Fixnum] :ftp_schedule_wed_0 
        # 	* [Fixnum] :ftp_schedule_wed_1 
        # 	* [Fixnum] :ftp_schedule_wed_2 
        # 	* [Fixnum] :ftp_schedule_thu_0 
        # 	* [Fixnum] :ftp_schedule_thu_1 
        # 	* [Fixnum] :ftp_schedule_thu_2 
        # 	* [Fixnum] :ftp_schedule_fri_0 
        # 	* [Fixnum] :ftp_schedule_fri_1 
        # 	* [Fixnum] :ftp_schedule_fri_2 
        # 	* [Fixnum] :ftp_schedule_sat_0 
        # 	* [Fixnum] :ftp_schedule_sat_1 
        # 	* [Fixnum] :ftp_schedule_sat_2 
        # 	* [FalseClass, TrueClass] :alarm_motion_armed
        # 	* [Fixnum] :alarm_motion_sensitivity
        # 	* [Fixnum] :alarm_motion_compensation 
        # 	* [FalseClass, TrueClass] :alarm_input_armed 
        # 	* [Fixnum] :alarm_ioin_level 
        # 	* [Fixnum] :alarm_iolinkage 
        # 	* [Fixnum] :alarm_preset 
        # 	* [Fixnum] :alarm_ioout_level 
        # 	* [FalseClass, TrueClass] :alarm_mail 
        # 	* [Fixnum] :alarm_upload_interval 
        # 	* [FalseClass, TrueClass] :alarm_http
        # 	* [FalseClass, TrueClass] :alarm_msn
        # 	* [String] :alarm_http_url
        # 	* [FalseClass, TrueClass] :alarm_schedule_enable
        # 	* [Fixnum] :alarm_schedule_sun_0 
        # 	* [Fixnum] :alarm_schedule_sun_1 
        # 	* [Fixnum] :alarm_schedule_sun_2 
        # 	* [Fixnum] :alarm_schedule_mon_0 
        # 	* [Fixnum] :alarm_schedule_mon_1 
        # 	* [Fixnum] :alarm_schedule_mon_2 
        # 	* [Fixnum] :alarm_schedule_tue_0 
        # 	* [Fixnum] :alarm_schedule_tue_1 
        # 	* [Fixnum] :alarm_schedule_tue_2 
        # 	* [Fixnum] :alarm_schedule_wed_0 
        # 	* [Fixnum] :alarm_schedule_wed_1 
        # 	* [Fixnum] :alarm_schedule_wed_2 
        # 	* [Fixnum] :alarm_schedule_thu_0 
        # 	* [Fixnum] :alarm_schedule_thu_1 
        # 	* [Fixnum] :alarm_schedule_thu_2 
        # 	* [Fixnum] :alarm_schedule_fri_0 
        # 	* [Fixnum] :alarm_schedule_fri_1 
        # 	* [Fixnum] :alarm_schedule_fri_2 
        # 	* [Fixnum] :alarm_schedule_sat_0 
        # 	* [Fixnum] :alarm_schedule_sat_1 
        # 	* [Fixnum] :alarm_schedule_sat_2 
        # 	* [Fixnum] :decoder_baud 
        # 	* [String] :msn_user
        # 	* [String] :msn_pwd
        # 	* [String] :msn_friend1
        # 	* [String] :msn_friend2
        # 	* [String] :msn_friend3
        # 	* [String] :msn_friend4
        # 	* [String] :msn_friend5
        # 	* [String] :msn_friend6
        # 	* [String] :msn_friend7
        # 	* [String] :msn_friend8
        # 	* [String] :msn_friend9
        # 	* [String] :msn_friend10
		def get_params
			response = @connection.get("get_params.cgi")
			response = response.success? ? parse_response(response) : {}
			unless response.empty?
				response[:now] = DateTime.strptime(response[:now],'%s')
				[:ntp_enable, :wifi_enable, :pppoe_enable, :upnp_enable, :alarm_schedule_enable, :ftp_schedule_enable].each do |field|
					response[field] = response[field].to_i > 0
				end
				[
					:ftp_schedule_sun_0, :ftp_schedule_sun_1, :ftp_schedule_sun_2, 
					:ftp_schedule_mon_0, :ftp_schedule_mon_1, :ftp_schedule_mon_2, 
					:ftp_schedule_tue_0, :ftp_schedule_tue_1, :ftp_schedule_tue_2, 
					:ftp_schedule_wed_0, :ftp_schedule_wed_1, :ftp_schedule_wed_2, 
					:ftp_schedule_thu_0, :ftp_schedule_thu_1, :ftp_schedule_thu_2, 
					:ftp_schedule_fri_0, :ftp_schedule_fri_1, :ftp_schedule_fri_2, 
					:ftp_schedule_sat_0, :ftp_schedule_sat_1, :ftp_schedule_sat_2,
					:alarm_schedule_sun_0, :alarm_schedule_sun_1, :alarm_schedule_sun_2, 
					:alarm_schedule_mon_0, :alarm_schedule_mon_1, :alarm_schedule_mon_2, 
					:alarm_schedule_tue_0, :alarm_schedule_tue_1, :alarm_schedule_tue_2, 
					:alarm_schedule_wed_0, :alarm_schedule_wed_1, :alarm_schedule_wed_2, 
					:alarm_schedule_thu_0, :alarm_schedule_thu_1, :alarm_schedule_thu_2, 
					:alarm_schedule_fri_0, :alarm_schedule_fri_1, :alarm_schedule_fri_2, 
					:alarm_schedule_sat_0, :alarm_schedule_sat_1, :alarm_schedule_sat_2,
					:daylight_savings_time, :ddns_proxy_port, :ftp_port, :mail_port, :port, :dev2_port, :dev3_port, :dev4_port, :dev5_port, :dev6_port, :dev7_port, :dev8_port, :dev9_port].each do |field|
					response[field] = response[field].to_i
				end
				[:user1_pri, :user2_pri, :user3_pri, :user4_pri, :user5_pri, :user6_pri, :user7_pri, :user8_pri].each do |key|
					response[key] = USER_PERMISSIONS[response[key].to_i]
				end	
			end
			response
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
		# @return [FalseClass,TrueClass] whether the request was successful.
		def set_users(params)
			[:user1, :pwd1, :user2, :pwd2, :user3, :pwd3, :user4, :pwd4, :user5, :pwd5, :user6, :pwd6, :user7, :pwd7, :user8, :pwd8].each do |key|
				throw "invalid parameter value" if params.has_key?(key) && params[key].length > 12
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

		def set_upnp(flag)
			response = @connection.get("set_upnp.cgi?enable=#{handle_boolean(flag)}")
			response.success?
		end

		def set_ddns(params)
			throw "invalid parameter value" if params.has_key?(:user) && params[:user].length > 20
			throw "invalid parameter value" if params.has_key?(:pwd) && params[:pwd].length > 20
			throw "invalid parameter value" if params.has_key?(:host) && params[:host].length > 40
			response = @connection.get("set_ddns.cgi?#{params.to_query}")
			response.success?
		end

		def set_ftp(params)
			response = @connection.get("set_ftp.cgi?#{params.to_query}")
			response.success?
		end

		def set_mail(params)
			throw "invalid parameter value" if params.has_key?(:user) && params[:user].length > 20
			throw "invalid parameter value" if params.has_key?(:pwd) && params[:pwd].length > 20
			[:sender, :receiver1, :receiver2, :receiver3, :receiver4].each do |key|
				throw "invalid parameter value" if params.has_key?(key) && params[key].length > 40
			end
			response = @connection.get("set_mail.cgi?#{params.to_query}")
			response.success?
		end

		def set_alarm(params)
			response = @connection.get("set_alarm.cgi?#{params.to_query}")
			response.success?
		end

		def comm_write(params)
			response = @connection.get("comm_write.cgi?#{params.to_query}")
			response.success?
		end

		def set_forbidden(params)
			response = @connection.get("set_forbidden.cgi?#{params.to_query}")
			response.success?
		end

		def get_forbidden
			response = @connection.get("get_forbidden.cgi")
			response.success? ? parse_response(response) : {}
		end

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

		def handle_boolean(flag)
			flag ? 1 : 0
		end

	end
end