require 'spec_helper'

describe Foscam::Model::WifiConfig do
  before(:each) do
    @wifi = Foscam::Model::WifiConfig.new(:enable=>"1", :ssid=>"my_wireless_ssid", :encrypt=>"3", :defkey=>"0", :key1=>"", :key2=>"", :key3=>"", :key4=>"", :authtype=>"0", :keyformat=>"0", :key1_bits=>"0", :key2_bits=>"0", :key3_bits=>"0", :key4_bits=>"0", :mode=>"0", :wpa_psk=>"my_wireless_password")
  end
  
  it "sets string fields" do
    [:ssid, :defkey, :key1, :key2, :key3, :key4, :wpa_psk].each do |method|
      @wifi.send(method).should be_a_kind_of(String)
    end
  end
  
  it "sets the authtype as a symbol" do
  	@wifi.authtype.should be_a_kind_of(Symbol)
  	Foscam::Model::WifiConfig::AUTH_TYPE.values.should include(@wifi.authtype)
  end
  
  it "sets the key_format as a string" do
  	@wifi.keyformat.should be_a_kind_of(Symbol)
  	Foscam::Model::WifiConfig::KEY_FORMAT.values.should include(@wifi.keyformat)
  end

  it "sets the encryption type as a string" do
  	@wifi.encryption.should be_a_kind_of(Symbol)
  	Foscam::Model::WifiConfig::ENCRYPTION_TYPE.values.should include(@wifi.encryption)
  end
  
  it "sets fixnum fields" do
    [:key1_bits, :key2_bits, :key3_bits, :key4_bits].each do |method|
      @wifi.send(method).should be_a_kind_of(Fixnum)
    end
  end
  
	it "sets ntp_enable as a Boolean" do
		@wifi.enable.should be_a_kind_of(Boolean)
	end

end
