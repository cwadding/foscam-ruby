module Foscam

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