module Foscam
	module Model
		class Network
      attr_accessor :ip, :mask, :gateway, :dns, :port

      def initialize(args = {})
        [:port].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field].to_i) unless args[field].nil?
        end
        [:ip, :mask, :gateway, :dns].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
		  end

      def to_hash
        [:ip, :mask, :gateway, :dns, :port].inject({}) do |h, key|
          h.merge!({key => send(key) }) unless send(key).nil?
          h
        end
      end

      def to_query
        to_hash.to_query
      end

		end
	end
end