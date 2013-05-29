module Foscam
	module Model
		class Clock
			attr_accessor :ntp_svr, :ntp_enable, :time, :daylight_saving_time
			# [:ntp_svr].length > 64
			def initialize(args = {})
				@ntp_svr = args[:ntp_svr] if args.has_key?(:ntp_svr) && !args[:ntp_svr].nil?
				@time = Time.find_zone(-args[:tz].to_i).at(args[:now].to_i) if args.has_key?(:now) && !args[:now].nil?
				[:daylight_saving_time, :ntp_enable].each do |field|
    	    		self.instance_variable_set("@#{field}".to_sym, args[field].to_i > 0) if args.has_key?(field) && !args[field].nil?
        		end
			end

			def to_hash
				h = {}
				h.merge!({:ntp_svr		=> self.ntp_svr }) unless ntp_svr.nil?
				h.merge!({:ntp_enable 	=> self.ntp_enable ? "1" : "0" }) unless ntp_enable.nil?
				h.merge!({:now 			=> self.time.to_i, :tz => -self.time.utc_offset }) unless time.nil?
				h.merge!({:daylight_saving_time 	=> self.daylight_saving_time ? "1" : "0" }) unless daylight_saving_time.nil?
				h
			end

			def to_query
				self.to_hash.to_query
			end
		end
	end
end