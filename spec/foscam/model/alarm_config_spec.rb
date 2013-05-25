require 'spec_helper'

describe Foscam::Model::AlarmConfig do
  before(:each) do
    @alarm = Foscam::Model::AlarmConfig.new(:motion_armed=>"1", :motion_sensitivity=>"0", :motion_compensation=>"0", :input_armed=>"1", :ioin_level=>"1", :iolinkage=>"0", :preset=>"0", :ioout_level=>"1", :mail=>"0", :upload_interval=>"2", :http=>"0", :msn=>"0", :http_url=>"", :schedule=>{:enable=>"1", :sun_0=>"0", :sun_1=>"4294967264", :sun_2=>"16383", :mon_0=>"0", :mon_1=>"4294967264", :mon_2=>"16383", :tue_0=>"0", :tue_1=>"4294967264", :tue_2=>"16383", :wed_0=>"0", :wed_1=>"4294967264", :wed_2=>"16383", :thu_0=>"0", :thu_1=>"4294967264", :thu_2=>"16383", :fri_0=>"0", :fri_1=>"4294967264", :fri_2=>"16383", :sat_0=>"0", :sat_1=>"4294967264", :sat_2=>"16383"})
  end
  it "sets boolean fields" do
    [:motion_armed, :input_armed, :msn, :mail, :http, :schedule_enable].each do |method|
      @alarm.send(method).should be_a_kind_of(Boolean)
    end
  end
  it "sets fixnum fields" do
    [:motion_sensitivity, :motion_compensation, :ioin_level, :iolinkage, :preset, :ioout_level, :upload_interval].each do |method|
      @alarm.send(method).should be_a_kind_of(Fixnum)
    end
  end
  it "sets the alarm_schedule as an Week" do
  	@alarm.schedule.should be_an_instance_of(Foscam::Schedule::Week)
  end
  
  it "responds to http_url as string" do
  	@alarm.http_url.should be_an_instance_of(String)
  end
  
end