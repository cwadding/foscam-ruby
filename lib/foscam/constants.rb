module Foscam
	# DDNS_STATUS
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

	# CAMERA_PARAMS_MODE
	CAMERA_PARAMS_MODE = {
		0 => "50hz",
		1 => "60hz",
		2 => "outdoor"
	}

	# CAMERA_CONTROL_MODE
	CAMERA_CONTROL_MODE = CAMERA_PARAMS_MODE.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	# CAMERA_PARAMS_ORIENTATION
	CAMERA_PARAMS_ORIENTATION = {
		0 => "default",
		1 => "flip",
		2 => "mirror",
		3 => "flip+mirror"
	}

	# CAMERA_CONTROL_ORIENTATION
	CAMERA_CONTROL_ORIENTATION = CAMERA_PARAMS_ORIENTATION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	# CAMERA_PARAMS_RESOLUTION
	CAMERA_PARAMS_RESOLUTION = {
		8 => "qvga",
		32 => "vga"
	}

	# CAMERA_CONTROL_RESOLUTION
	CAMERA_CONTROL_RESOLUTION = CAMERA_PARAMS_RESOLUTION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

	# CAMERA_CONTROLS
	CAMERA_CONTROLS = {
		:resolution => 0,
		:brightness => 1,
		:contrast 	=> 2,
		:mode 		=> 3,
		:flip 		=> 5
	}

	# DECODER_CONTROLS
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

	# USER_PERMISSIONS
	USER_PERMISSIONS = {
		0 => :visitor,
		1 => :operator,
		2 => :administrator
	}

	# USER_PERMISSIONS_ID
	USER_PERMISSIONS_ID = USER_PERMISSIONS.invert

	# PTZ_AUTO_PATROL_TYPE
	PTZ_AUTO_PATROL_TYPE = {
		0 => :none,
		1 => :horizontal,
		2 => :vertical,
		3 => :"horizontal+vertical"
	}

	# PTZ_AUTO_PATROL_TYPE_ID
	PTZ_AUTO_PATROL_TYPE_ID = PTZ_AUTO_PATROL_TYPE.invert

	# LED_MODE
	LED_MODE = {
		0 => :mode1,
		1 => :mode2,
		2 => :disabled
	}

	# LED_MODE_ID
	LED_MODE_ID = LED_MODE.invert
	
	# DECODER_BAUD
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
	# DECODER_BAUD_ID
	DECODER_BAUD_ID = DECODER_BAUD.invert
end