module Foscam
	module ActiveModel
		class Network < Base
			
			include Singleton

	        attr_reader :ip_address, :mask, :gateway, :dns, :port

	        define_model_callbacks :save


	        def ip_address=(val)
				ip_address_will_change! unless val == @ip_address
				@ip_address = val
			end

			def mask=(val)
				mask_will_change! unless val == @mask
				@mask = val
			end

			def gateway=(val)
				gateway_will_change! unless val == @gateway
				@gateway = val
			end

			def dns=(val)
				dns_will_change! unless val == @dns
				@dns = val
			end

			def port=(val)
				port_will_change! unless val == @port
				@port = val
			end

			def client=(obj)
				unless obj.nil?
					Network::client = obj
					params = client.get_params
					unless params.empty?
						self.ip_address = params[:ip]
						self.mask = params[:mask]
						self.gateway = params[:gateway]
						self.dns = params[:dns]
						self.port = params[:port]
					end
				end
			end

			define_attribute_methods [:ip_address, :mask, :gateway, :dns, :port]

			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid?
						@previously_changed = changes
						flag = client.set_network(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({:ip 		=> self.ip_address }) if ip_address_changed?
				h.merge!({:mask 	=> self.mask }) if mask_changed?
				h.merge!({:gateway 	=> self.gateway }) if gateway_changed?
				h.merge!({:dns 		=> self.dns }) if dns_changed?
				h.merge!({:port 	=> self.port }) if port_changed?
				h
			end

		end
	end
end