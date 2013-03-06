require 'rubygems'
require 'bundler/setup'

require 'vcr'
# require 'debugger'
require 'foscam-ruby' # and any other gems you need

FOSCAM_USERNAME = 'my_username'
FOSCAM_PASSWORD = 'my_password'
FOSCAM_URL = "http://192.168.0.117/"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock
  # c.allow_http_connections_when_no_cassette = true
end

module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

RSpec.configure do |config|
  # some (optional) config here
end