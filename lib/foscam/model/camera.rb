
module Foscam
	module Model
		class Camera
      
      # CAMERA_PARAMS_MODE
    	CAMERA_PARAMS_MODE = {
    		0 => "50hz",
    		1 => "60hz",
    		2 => "outdoor"
    	}
    	
    	
    	# CAMERA_PARAMS_ORIENTATION
    	CAMERA_PARAMS_ORIENTATION = {
    		0 => "default",
    		1 => "flip",
    		2 => "mirror",
    		3 => "flip+mirror"
    	}


    	# CAMERA_PARAMS_RESOLUTION
    	CAMERA_PARAMS_RESOLUTION = {
    		8 => "qvga",
    		32 => "vga"
    	}
    	
    	# CAMERA_CONTROLS
    	CAMERA_CONTROLS = {
    		:resolution => 0,
    		:brightness => 1,
    		:contrast 	=> 2,
    		:mode 		=> 3,
    		:flip 		=> 5
    	}
    	
    	
    	# CAMERA_CONTROL_MODE
    	CAMERA_CONTROL_MODE = CAMERA_PARAMS_MODE.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}

    	# CAMERA_CONTROL_ORIENTATION
    	CAMERA_CONTROL_ORIENTATION = CAMERA_PARAMS_ORIENTATION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}


    	# CAMERA_CONTROL_RESOLUTION
    	CAMERA_CONTROL_RESOLUTION = CAMERA_PARAMS_RESOLUTION.inject({}){|memo,(k,v)| memo[v.to_sym] = k; memo}
    	
			attr_accessor :resolution, :brightness, :contrast, :orientation, :mode




      def initialize(args = {})
			  @orientation = CAMERA_PARAMS_ORIENTATION[args[:flip].to_i]
			  @mode = CAMERA_PARAMS_MODE[args[:mode].to_i]
			  @resolution = CAMERA_PARAMS_RESOLUTION[args[:resolution].to_i]
			  [:brightness, :contrast].each {|field| self.instance_variable_set("@#{field}".to_sym, args[field].to_i)}
		  end
		end
	end
end