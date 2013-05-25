module Foscam
	module Model
		class MailServer

			class Recipient
			  
				attr_accessor :id, :address

				def initialize(params = nil)
					params.each do |attr, value|
						self.public_send("#{attr}=", value)
					end if params
				end

			end

			attr_accessor :user, :pwd, :svr, :port, :sender, :receiver1, :receiver2, :receiver3, :receiver4, :inet_ip, :tls

      def initialize(args = {})
        [:svr, :user, :pwd, :inet_ip, :sender, :receiver1, :receiver2, :receiver3, :receiver4].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
        [:port, :tls].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field].to_i)
        end
		  end


		end
	end
end