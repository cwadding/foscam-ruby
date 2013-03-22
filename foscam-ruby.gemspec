# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foscam/version'

Gem::Specification.new do |spec|
  spec.name          = "foscam-ruby"
  spec.version       = Foscam::VERSION
  spec.authors       = ["Chris Waddington"]
  spec.email         = ["cwadding@gmail.com"]
  spec.description   = %q{A ruby client for the foscam SDK.}
  spec.summary       = %q{A ruby client for the foscam SDK.}
  spec.homepage      = "https://github.com/cwadding/foscam-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'active_support'
  spec.add_dependency 'activemodel'

  spec.add_development_dependency "debugger"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'#, '~> 2.10.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
