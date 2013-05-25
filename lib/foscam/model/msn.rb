module Foscam
	module Model
		class Msn
			class Friend
  			##
  			# @!attribute [r] id
  			#   @return [Fixnum] The id of the msn friend
  			attr_accessor :id
  						  
			  ##
  			# @!attribute [r] id
  			#   @return [Fixnum] The name of the msn friend
  			attr_accessor :name
  			
  			def initialize(args = {})

        end
        
		  end
		  
			# Max number of friends supported by Foscam msn feature
			MAX_NUMBER = 10
			
      def initialize(args = {})
        [:friend1, :friend2, :friend3, :friend4, :friend5, :friend6, :friend7, :friend8, :friend9, :friend10].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
        [:user, :pwd].each do |field|
          self.instance_variable_set("@#{field}".to_sym, args[field])
        end
      end
			##
			# @!attribute [rw] username
			#   @return [String] The name of the host msn account
			attr_accessor :user

			##
			# @!attribute [rw] password
			#   @return [String] The password of the host msn account
			attr_accessor :pwd
			
			##
			# @!attribute [rw] friends
			#   @return [Array] list of up to 10 Msn Friends
      # attr_accessor :friends
      attr_accessor :friend1, :friend2, :friend3, :friend4, :friend5, :friend6, :friend7, :friend8, :friend9, :friend10
    end
	end
end