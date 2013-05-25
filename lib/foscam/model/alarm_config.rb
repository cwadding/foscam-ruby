module Foscam
	module Model
		class AlarmConfig

			attr_accessor :motion_armed, :motion_sensitivity, :motion_compensation, :input_armed, :ioin_level, :iolinkage, :preset, :ioout_level, :mail, :upload_interval, :http, :http_url, :msn, :schedule_enable, :schedule

			def initialize(params ={})
			  
			  [:motion_armed, :input_armed, :msn, :mail, :http, :schedule_enable].each do |field|
			    self.instance_variable_set("@#{field}".to_sym, params[field].to_i > 0)
		    end
		    [:motion_sensitivity, :motion_compensation, :ioin_level, :iolinkage, :preset, :ioout_level, :upload_interval].each do |field|
		      self.instance_variable_set("@#{field}".to_sym, params[field].to_i)
	      end
		    [:http_url].each do |field|
		      self.instance_variable_set("@#{field}".to_sym, params[field])
	      end
        @schedule = ::Foscam::Schedule::Week.new(params[:schedule])
			end
    end
	end
end