require 'spec_helper'

describe Foscam::Model::Device do
	before(:each) do
		@device = Foscam::Model::Device.new(:id=>"000DC5D4DC51", :sys_ver=>"11.22.2.38", :app_ver=>"2.4.18.17", :alias=>"", :alarm_status => "0", :ddns_status => "0", :upnp_status => "0")
	end

	it "responds to string parameters" do
		[:id, :sys_ver, :app_ver, :alias].each do |method|
			@device.send(method).should be_an_instance_of(String)
		end
	end  
  
	it "sets the ddns status string" do
		@device.ddns_status.should be_a_kind_of(String)
		::Foscam::Model::Device::DDNS_STATUS.values.should include(@device.ddns_status)
	end

	it "sets the upnp status string" do
		@device.upnp_status.should be_a_kind_of(String)
		::Foscam::Model::Device::UPNP_STATUS.values.should include(@device.upnp_status)
	end

	it "sets the alarm status string" do
		@device.alarm_status.should be_a_kind_of(String)
		::Foscam::Model::Device::ALARM_STATUS.values.should include(@device.alarm_status)
	end

  
end