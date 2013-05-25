module Foscam
	module ActiveModel
		class AlarmConfig < Base
			include Singleton

			define_model_callbacks :save

			attr_reader :motion_armed, :motion_sensitivity, :motion_compensation, :input_armed, :ioin_level, :iolinkage, :preset, :ioout_level, :mail, :upload_interval, :http, :http_url, :msn, :schedule_enable, :schedule


			def motion_armed=(val)
				motion_armed_will_change! unless val == @motion_armed
				@motion_armed = val
			end

			def motion_sensitivity=(val)
				motion_sensitivity_will_change! unless val == @motion_sensitivity
				@motion_sensitivity = val
			end

			def motion_compensation=(val)
				motion_compensation_will_change! unless val == @motion_compensation
				@motion_compensation = val
			end

			def input_armed=(val)
				input_armed_will_change! unless val == @input_armed
				@input_armed = val
			end

			def ioin_level=(val)
				ioin_level_will_change! unless val == @ioin_level
				@ioin_level = val
			end

			def iolinkage=(val)
				iolinkage_will_change! unless val == @iolinkage
				@iolinkage = val
			end

			def preset=(val)
				preset_will_change! unless val == @preset
				@preset = val
			end

			def ioout_level=(val)
				ioout_level_will_change! unless val == @ioout_level
				@ioout_level = val
			end

			def mail=(val)
				mail_will_change! unless val == @mail
				@mail = val
			end
			

			def upload_interval=(val)
				upload_interval_will_change! unless val == @upload_interval
				@upload_interval = val
			end

			def http=(val)
				http_will_change! unless val == @http
				@http = val
			end

			def http_url=(val)
				http_url_will_change! unless val == @http_url
				@http_url = val
			end

			def msn=(val)
				msn_will_change! unless val == @msn
				@msn = val
			end

			def schedule_enable=(val)
				schedule_enable_will_change! unless val == @schedule_enable
				@schedule_enable = val
			end

			def schedule=(val)
				schedule_will_change! unless val == @schedule
				@schedule = val
			end

			def client=(obj)
				unless obj.nil?
					AlarmConfig::client = obj
					params = client.get_params
					unless params.empty?
						self.motion_armed = params[:alarm_motion_armed]
						self.motion_sensitivity = params[:alarm_motion_sensitivity]
						self.motion_compensation = params[:alarm_motion_compensation]
						self.input_armed = params[:alarm_input_armed]
						self.ioin_level = params[:alarm_ioin_level]
						self.iolinkage = params[:alarm_iolinkage]
						self.preset = params[:alarm_preset]
						self.ioout_level = params[:alarm_ioout_level]
						self.mail = params[:alarm_mail]
						self.http = params[:alarm_http]
						self.msn = params[:alarm_msn]
						self.http_url = params[:alarm_http_url]	
						self.schedule_enable = params[:alarm_schedule_enable]
						self.schedule = params[:alarm_schedule]	
					end
				end
			end

			define_attribute_methods [:motion_armed, :motion_sensitivity, :motion_compensation, :input_armed, :ioin_level, :iolinkage, :preset, :ioout_level, :mail, :upload_interval, :http, :http_url, :msn, :schedule_enable, :schedule]

			def save
				run_callbacks :save do
					flag = false
					if changed? && is_valid?
						@previously_changed = changes
						flag = client.set_alarm(dirty_params_hash)
						@changed_attributes.clear if flag
					end
					flag
				end
			end

			private

			def dirty_params_hash
				h = {}
				h.merge!({:motion_armed 		=> self.motion_armed }) if motion_armed_changed?
				h.merge!({:motion_sensitivity 	=> self.motion_sensitivity }) if motion_sensitivity_changed?
				h.merge!({:motion_compensation 	=> self.motion_compensation }) if motion_compensation_changed?
				h.merge!({:input_armed 			=> self.input_armed }) if input_armed_changed?
				h.merge!({:ioin_level 			=> self.ioin_level }) if ioin_level_changed?
				h.merge!({:iolinkage 			=> self.iolinkage }) if iolinkage_changed?
				h.merge!({:preset 				=> self.preset }) if preset_changed?
				h.merge!({:ioout_level 			=> self.ioout_level }) if ioout_level_changed?
				h.merge!({:mail 				=> self.mail }) if mail_changed?
				h.merge!({:upload_interval		=> self.upload_interval }) if upload_interval_changed?
				h.merge!({:http 				=> self.http }) if http_changed?
				h.merge!({:msn 					=> self.msn }) if msn_changed?
				# h.merge!({:http_url 			=> self.http_url }) if http_url_changed?
				h.merge!({:schedule_enable 		=> self.schedule_enable }) if schedule_enable_changed?
				# h.merge!({:schedule 			=> self.schedule }) if schedule_changed?
				h
			end
		end
	end
end