require 'spec_helper'

describe Foscam::Model::Clock do
	before(:each) do
		@clock = Foscam::Model::Clock.new(:now=>"1352782970", :tz=>"18000", :daylight_saving_time=>"0", :ntp_enable=>"1", :ntp_svr=>"0.ca.pool.ntp.org", )
	end
  
	it "sets svr string fields" do
		@clock.ntp_svr.should be_a_kind_of(String)
	end

	it "sets now as datetime" do
		@clock.time.should be_a_kind_of(ActiveSupport::TimeWithZone)
	end

	it "sets boolean fields" do
		[:daylight_saving_time, :ntp_enable].each do |method|
			@clock.send(method).should be_a_kind_of(Boolean)
		end
	end

end
