module Foscam
	module Model
		class NtpServer
      attr_accessor :svr, :enable

      def initialize(args = {})
         @svr = args[:svr] if args.has_key?(:svr) && !args[:svr].nil?
         @enable = args[:enable].to_i > 0 if args.has_key?(:enable) && !args[:enable].nil?
		  end
		  
		end
	end
end