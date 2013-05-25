		# 	* :ftp_svr  (String)
		# 	* :ftp_port  (String)
		# 	* :ftp_user  (String)
		# 	* :ftp_pwd  (String)
		# 	* :ftp_dir  (String)
		# 	* :ftp_mode  (String)
		# 	* :ftp_upload_interval  (String)
		# 	* :ftp_filename  (String)
		# 	* :ftp_numberoffiles (Fixnum)
		# 	* :ftp_schedule_enable (FalseClass, TrueClass)
		# 	* :ftp_schedule (Fixnum)

module Foscam
	module Model
		class FtpServer

			attr_reader :dir, :user, :pwd, :svr, :port, :upload_interval, :schedule, :schedule_enable, :filename, :mode, :numberoffiles

      def initialize(args = {})
        @schedule = ::Foscam::Schedule::Week.new(args[:schedule])
        [:svr, :user, :pwd, :dir, :filename].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
        [:port, :upload_interval, :mode, :numberoffiles].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field].to_i)
        end
        [:schedule_enable].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field].to_i > 0)
        end
		  end

	     #     ftp_match = field.to_s.match(/ftp_schedule_(.+)_(\d)/)
	     #     unless ftp_match.nil?
	     #       value = params.delete(field)
	     #       ftp_schedule.merge!("#{ftp_match[1]}_#{ftp_match[2]}".to_sym => value.to_i)
	     #     end
	     #   response[:ftp_schedule] = ::Foscam::Schedule::Week.new(ftp_schedule)
	     
	     #   [:ftp_schedule_enable].each do |field|
	     #     response[field] = response[field].to_i > 0
	     #   end

		end
	end
end