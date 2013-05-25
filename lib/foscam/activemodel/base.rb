module Foscam
	module ActiveModel
		class Base
			include ::ActiveModel::Dirty
			include ::ActiveModel::Validations
			include ::ActiveModel::Conversion
			extend ::ActiveModel::Callbacks
			extend ::ActiveModel::Naming
			extend ::ActiveModel::Translation


			# the Foscam client connection
			cattr_accessor :client

			define_model_callbacks :initialize, :only => [:after]
			##
			# @param params [Hash] Device attributes
			# @option params [Fixnum] :resolution
			# @option params [Fixnum] :brightness
			# @option params [Fixnum] :contrast
			# @option params [String] :orientation
			def initialize(params ={})
				# Check if it is a Hash
				# get the parameters and set them to the attributes
				run_callbacks :initialize do
					params.each do |attr, value|
						self.public_send("#{attr}=", value)
					end if params
				end
				# Check if it is a Foscam::Client
			end

			##
			# Connects to the foscam webcam
			# @param url [String] The address to your camera
			# @param username [String] username to authorize with the camera
			# @param password [String] password to authorize with the camera
			def connect(params)
				client = ::Foscam::Client.new(params) if params.has_key?(:url)
			end

			#:nodoc
			def persisted?
				true
			end
		end
	end
end