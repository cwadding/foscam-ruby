require 'spec_helper'

# 	* :ddns_service (String)
# 	* :ddns_user (String)
# 	* :ddns_pwd (String)
# 	* :ddns_host (String)
# 	* :ddns_proxy_svr (String)
# 	* :ddns_proxy_port (Fixnum)

describe Foscam::Model::Ddns do
  before(:each) do
    @ddns = Foscam::Model::Ddns.new(:service=>"0", :user=>"", :pwd=>"", :host=>"", :proxy_svr=>"", :proxy_port=>"0")
  end

  it "sets string variables" do
    [:service, :user, :pwd, :host, :proxy_svr].each do |method|
  	  @ddns.send(method).should be_an_instance_of(String)
	  end
  end
  
  it "sets the port as a fixnum fields" do
    [:proxy_port].each do |method|
      @ddns.send(method).should be_a_kind_of(Fixnum)
    end
  end
  
end
