require 'spec_helper'

describe Foscam::Model::NtpServer do
  before(:each) do
    @ntp = Foscam::Model::NtpServer.new(:enable=>"1", :svr=>"0.ca.pool.ntp.org")
  end
  
  it "sets svr string fields" do
   @ntp.svr.should be_a_kind_of(String)
  end
  
	it "sets ntp_enable as a Boolean" do
		@ntp.enable.should be_a_kind_of(Boolean)
	end 
end
