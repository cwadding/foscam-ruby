require "foscam/version"
require "faraday"
require "mini_magick"
require "active_support/core_ext/object/to_query"
require "active_support/core_ext/class/attribute_accessors"
require "date"
require "date"
require "active_model"

module Foscam
	autoload :Client, 'foscam/client'
	module Model
		autoload :User, 'foscam/model/user'
		autoload :Device, 'foscam/model/device'
	end
end