require "foscam/version"
require "faraday"
require "mini_magick"
require "active_support/core_ext/object/to_query"

module Foscam
	autoload :Client, 'foscam/client'
end