module Foscam
	module Model
		class Ddns
      attr_accessor :service, :user, :pwd, :host, :proxy_svr, :proxy_port
	     
       def initialize(args = {})
          [:service, :user, :pwd, :host, :proxy_svr].each do |field|
            self.instance_variable_set("@#{field}".to_sym, args[field])
      	  end
          [:proxy_port].each do |field|
            self.instance_variable_set("@#{field}".to_sym, args[field].to_i)
          end
       end
       
		end
	end
end