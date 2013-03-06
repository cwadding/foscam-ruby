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
		resolution: 0,
		brightness: 1,
		contrast: 2,
		mode: 3,
		flip: 5
	}

	DECODER_CONTROLS = {
		up: 0,
		stop_up: 1,
		down: 2,
		stop_down: 3,
		left: 4,
		stop_left: 5,
		right: 6,
		stop_right: 7,
		center: 25,
		vertical_patrol: 26,
		stop_vertical_patrol: 27,
		horizon_patrol: 28,
		stop_horizon_patrol: 29,
		io_output_high: 94,
		io_output_low: 95,
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

		def connect(url, username = nil, password = nil)
			@url = url
			@username = username
			@password = password
			@connection = Faraday.new( url: @url) unless @url.nil?
			@connection.basic_auth(@username, @password) unless @username.nil? && @password.nil?
		end

		def snapshot
			response = @connection.get('snapshot.cgi')
			response.success? ? ::MiniMagick::Image.read(response.body) : nil
		end

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

		def reboot
			response = @connection.get("reboot.cgi")
			response.success?
		end

		def restore_factory
			response = @connection.get("restore_factory.cgi")
			response.success?
		end

		def get_params
			response = @connection.get("get_params.cgi")
			response = response.success? ? parse_response(response) : {}
			unless response.empty?
				response[:now] = DateTime.strptime(response[:now],'%s')
				[:ntp_enable, :wifi_enable, :pppoe_enable, :upnp_enable, :alarm_schedule_enable, :ftp_schedule_enable].each do |field|
					response[field] = response[field].to_i > 0
				end
				[:ftp_schedule_sun_0, :ftp_schedule_sun_1, :ftp_schedule_sun_2, 
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

		def upgrade_firmware
			response = @connection.post("upgrade_firmware.cgi")
		end

		def upgrade_htmls
			response = @connection.post("upgrade_htmls.cgi")
		end

		def set_alias(name)
			throw "invalid parameter value" if name.length > 20
			response = @connection.get("set_alias.cgi?alias=#{name}")
			response.success?
		end

		def set_datetime(params)
			# Extract the time zone
			throw "invalid parameter value" if params.has_key?(:ntp_svr) && params[:ntp_svr].length > 64
			response = @connection.get("set_datetime.cgi?#{params.to_query}")
			response.success?
		end

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

		def set_network(params)
			response = @connection.get("set_network.cgi?#{params.to_query}")
			response.success?
		end

		def set_wifi(params)
			response = @connection.get("set_wifi.cgi?#{params.to_query}")
			response.success?
		end

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