module Foscam
	module Model
		class User
			
			
			# USER_PERMISSIONS
    	USER_PERMISSIONS = {
    		0 => :visitor,
    		1 => :operator,
    		2 => :administrator
    	}
    	
    	# USER_PERMISSIONS_ID
    	USER_PERMISSIONS_ID = USER_PERMISSIONS.invert
    	
			# Max number of users supported by foscam
			MAX_NUMBER = 8
			
			##
			# @!attribute [r] id
			#   @return [Fixnum] The id of the user
			attr_accessor :id

			##
			# @!attribute [rw] username
			#   @return [String] The name of the user
			attr_accessor :name

			##
			# @!attribute [rw] password
			#   @return [String] The password of the user
			attr_accessor :pwd

			##
			# @!attribute [rw] privilege
			#   @return [Symbol] The privilege of the user
			attr_accessor :privilege
			
			def initialize(args = {})
			  @id = args[:id] if args.has_key?(:id) && !args[:id].nil?
    		[:name, :pwd].each do |field|
    			self.instance_variable_set("@#{field}".to_sym, args[field])
    		end
    		@privilege = USER_PERMISSIONS[args[:pri].to_i] if args.has_key?(:pri) && !args[:pri].nil?
		  end
      
			
    end
	end
end