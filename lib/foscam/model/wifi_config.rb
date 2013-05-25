module Foscam
	module Model
		class WifiConfig
	     #   [:wifi_enable].each do |field|
	     #     response[field] = response[field].to_i > 0
	     #   end
	      attr_accessor :enable, :ssid, :encryption, :defkey, :key1, :key2, :key3, :key4, :authtype, :keyformat, :key1_bits, :key2_bits, :key3_bits, :key4_bits, :mode, :wpa_psk
	     AUTH_TYPE = {
	       0 => :open,
	       1 => :share
	     }
	     KEY_FORMAT = {
	       0 => :Hex,
	       1 => :ASCII 
	     }
	     ENCRYPTION_TYPE = {
	       0 => :none,
	       1 => :wep,
	       2 => :wep_tkip,
	       3 => :wep_aes,
	       4 => :wep2_aes,
	       5 => :wep2_tkip_aes,
	     }
	     
       def initialize(args = {})
           [:ssid, :defkey, :key1, :key2, :key3, :key4, :wpa_psk].each do |field|
             self.instance_variable_set("@#{field}".to_sym, args[field])
           end
          @authtype = AUTH_TYPE[args[:authtype].to_i] if args.has_key?(:authtype) && !args[:authtype].nil?
          @keyformat = KEY_FORMAT[args[:keyformat].to_i] if args.has_key?(:keyformat) && !args[:keyformat].nil?
          @encryption = ENCRYPTION_TYPE[args[:encrypt].to_i] if args.has_key?(:encrypt) && !args[:encrypt].nil?

           [:key1_bits, :key2_bits, :key3_bits, :key4_bits].each do |field|
             self.instance_variable_set("@#{field}".to_sym, args[field].to_i)
           end
       		@enable = args[:enable].to_i > 0 if args.has_key?(:enable) && !args[:enable].nil?
       		
       end
       
       
		end
	end
end