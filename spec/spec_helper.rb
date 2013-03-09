require 'rubygems'
require 'bundler/setup'

require 'vcr'
require 'foscam-ruby' # and any other gems you need


FOSCAM_USERNAME = 'my_username' #:nodoc:all
FOSCAM_PASSWORD = 'my_password' #:nodoc:all
FOSCAM_URL = "http://192.168.0.117/" #:nodoc:all

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
  # c.allow_http_connections_when_no_cassette = true
end


module Boolean #:nodoc:all
end
class TrueClass #:nodoc:all
	include Boolean
end
class FalseClass #:nodoc:all
	include Boolean
end

RSpec.configure do |config|
  # some (optional) config here
end