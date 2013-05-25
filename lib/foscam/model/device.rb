
module Foscam
	module Model
		class Device
		  
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

    	# UPNP_STATUS
    	UPNP_STATUS = {
    		0 => "No Action",
    		1 => "Succeed",
    		2 => "Device System Error",
    		3 => "Errors in Network Communication",
    		4 => "Errors in Chat with UPnP Device",
    		5 => "Rejected by UPnP Device, Maybe Port Conflict"
    	}

    	# ALARM_STATUS
    	ALARM_STATUS = {
    		0 => "No alarm",
    		1 => "Motion alarm",
    		2 => "Input Alarm"
    	}
      
      # 	* :now (DateTime) The current time on the camera
  		# 	* :alarm_status (String) Returns an Alarm status
  		# 	* :ddns_status (String) Returns an UPNP status
  		# 	* :upnp_status (String) Returns an DDNS status
  		
			attr_reader :id, :sys_ver, :app_ver, :alias, :time, :daylight_saving_time, :alarm_status, :ddns_status, :ddns_host, :oray_type, :upnp_status, :p2p_status, :p2p_local_port, :msn_status, :http_url

      def initialize(args = {})
  			@ddns_status = DDNS_STATUS[args[:ddns_status].to_i] if args.has_key?(:ddns_status) && !args[:ddns_status].nil?
  			@upnp_status = UPNP_STATUS[args[:upnp_status].to_i] if args.has_key?(:upnp_status) && !args[:upnp_status].nil?
  			@alarm_status = ALARM_STATUS[args[:alarm_status].to_i] if args.has_key?(:alarm_status) && !args[:alarm_status].nil?
  			@time = Time.find_zone(-args[:tz].to_i).at(args[:now].to_i) if args.has_key?(:now) && !args[:now].nil?
  			[:id, :sys_ver, :app_ver, :alias].each do |field|
      	  self.instance_variable_set("@#{field}".to_sym, args[field])
    	  end
    	  [:daylight_saving_time].each do |field|
    	    self.instance_variable_set("@#{field}".to_sym, args[field].to_i > 0)
        end
        
		  end
			

		end
	end
end