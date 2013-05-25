require 'spec_helper'

describe Foscam::Model::Network do
  before(:each) do
    @network = Foscam::Model::Network.new(:port=>"80", :ip=>"0.0.0.0", :mask=>"0.0.0.0", :gateway=>"0.0.0.0", :dns=>"0.0.0.0")
  end
  
  it "sets string fields" do
    [:ip, :mask, :gateway, :dns].each do |method|
      @network.send(method).should be_a_kind_of(String)
    end
  end
  it "sets fixnum fields" do
    [:port].each do |method|
      @network.send(method).should be_a_kind_of(Fixnum)
    end
  end
  
end