require 'spec_helper'

describe Foscam::Model::FtpServer do
  before(:each) do
    @ftp = Foscam::Model::FtpServer.new(:svr=>"192.168.0.148", :port=>"21", :user=>"my_username", :pwd=>"secret", :dir=>"R2D2", :mode=>"1", :upload_interval=>"0", :filename=>"", :numberoffiles=>"0", 
      :schedule=>{:enable=>"0", :sun_0=>"0", :sun_1=>"0", :sun_2=>"0", :mon_0=>"0", :mon_1=>"0", :mon_2=>"0", :tue_0=>"0", :tue_1=>"0", :tue_2=>"0", :wed_0=>"0", :wed_1=>"0", :wed_2=>"0", :thu_0=>"0", :thu_1=>"0", :thu_2=>"0", :fri_0=>"0", :fri_1=>"0", :fri_2=>"0", :sat_0=>"0", :sat_1=>"0", :sat_2=>"0"}
      )
  end
  
  it "sets string fields" do
    [:svr, :user, :pwd, :dir, :filename].each do |method|
      @ftp.send(method).should be_a_kind_of(String)
    end
  end
  it "sets fixnum fields" do
    [:port, :upload_interval, :mode, :numberoffiles].each do |method|
      @ftp.send(method).should be_a_kind_of(Fixnum)
    end
  end
  it "sets the alarm_schedule as an Week" do
  	@ftp.schedule.should be_an_instance_of(Foscam::Schedule::Week)
  end
  
  it "responds to http_url as string" do
    [:schedule_enable].each do |method|
      @ftp.send(method).should be_a_kind_of(Boolean)
    end
  end
end