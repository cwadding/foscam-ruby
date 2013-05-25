require 'spec_helper'

describe Foscam::Model::MailServer do
  before(:each) do
    @mail = Foscam::Model::MailServer.new(:svr=>"", :port=>"0", :tls=>"0", :user=>"", :pwd=>"", :sender=>"", :receiver1=>"", :receiver2=>"", :receiver3=>"", :receiver4=>"", :inet_ip=>"0")
  end
  
  it "sets string fields" do
    [:svr, :user, :pwd, :inet_ip, :sender, :receiver1, :receiver2, :receiver3, :receiver4].each do |method|
      @mail.send(method).should be_a_kind_of(String)
    end
  end
  it "sets fixnum fields" do
    [:port, :tls].each do |method|
      @mail.send(method).should be_a_kind_of(Fixnum)
    end
  end  
end