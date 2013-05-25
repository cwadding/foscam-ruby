module Foscam
	module Model
		class Network
      attr_accessor :ip, :mask, :gateway, :dns, :port

      def initialize(args = {})
        [:port].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field].to_i)
        end
        [:ip, :mask, :gateway, :dns].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
		  end


		end
	end
end