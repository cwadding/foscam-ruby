module Foscam
	class Connection
	  
	  # @!attribute [rw] url
		#   @return [String] the url to the camera
		attr_accessor :url
		# @!attribute [rw] username
		#   @return [String] The username for authentication to the camera
		attr_accessor :username
		# @!attribute [rw] password
		#   @return [String] The password for authentication to the camera
		attr_accessor :password
	  
	  
		def initialize(args = {})
			@url = args.delete(:url)
			@username = args.delete(:username)
			@password = args.delete(:password)
		end

		##
		# Connects to the foscam webcam
		# @param url [String] The address to your camera
		# @param username [String] username to authorize with the camera
		# @param password [String] password to authorize with the camera
		# @example connect to a camera
		# 	client = Foscam::Client.new
		# 	client.connect('http://192.168.0.1', 'foobar', 'secret')
		def connect(params = {})
			@url = params[:url] if params.has_key?(:url)
			@username = params[:username] if params.has_key?(:username)
			@password = params[:password] if params.has_key?(:password)
			@connection = Faraday.new( :url => @url) unless @url.nil?
			@connection.basic_auth(@username, @password) unless @username.nil? && @password.nil?
		end
	  
  end
end