require "foscam/version"
require "faraday"
require "mini_magick"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/to_query"
require "active_support/core_ext/class/attribute_accessors"
require "active_support/core_ext/time/zones"
require "active_support/core_ext/date_time/zones"
require "date"
require "active_model"
require 'singleton'

require 'foscam/activemodel/base'

module Foscam
	autoload :Client, 'foscam/client'
	autoload :Connection, 'foscam/connection'
	module Model
		autoload :AlarmConfig,'foscam/model/alarm_config'
		autoload :Ddns,       'foscam/model/ddns'
		autoload :Camera, 		'foscam/model/camera'
		autoload :Device, 		'foscam/model/device'
    autoload :FtpServer, 	'foscam/model/ftp_server'
    autoload :MailServer,	'foscam/model/mail_server'
    autoload :Msn,	      'foscam/model/msn'
		autoload :Network,		'foscam/model/network'
		autoload :NtpServer, 	'foscam/model/ntp_server'
		autoload :User, 		  'foscam/model/user'
		autoload :WifiConfig, 'foscam/model/wifi_config'
	end

	module ActiveModel
		autoload :AlarmConfig,	'foscam/activemodel/alarm_config'
		autoload :Device, 		  'foscam/activemodel/device'
		autoload :FtpServer, 	  'foscam/activemodel/ftp_server'
		autoload :MailServer,	  'foscam/activemodel/mail_server'
		autoload :Network,		  'foscam/activemodel/network'
		autoload :User, 		    'foscam/activemodel/user'
	end


	module Schedule
		autoload :Week,		 	'foscam/schedule/week'
		autoload :Day,	 		'foscam/schedule/day'
		autoload :ThirdOfADay,	'foscam/schedule/third_of_a_day'
	end
end