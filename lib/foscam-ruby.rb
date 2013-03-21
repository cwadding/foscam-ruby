require "foscam/version"
require "faraday"
require "mini_magick"
require "active_support/core_ext/object/to_query"
require "active_support/core_ext/class/attribute_accessors"
require "date"
require "date"
require "active_model"
require 'singleton'

require 'foscam/model/base'

module Foscam
	autoload :Client, 'foscam/client'
	module Model
		autoload :User, 'foscam/model/user'
		autoload :Device, 'foscam/model/device'
		autoload :FtpServer, 'foscam/model/ftp_server'
		autoload :MailServer, 'foscam/model/mail_server'
	end
end