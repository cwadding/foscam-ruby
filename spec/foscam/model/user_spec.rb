require 'spec_helper'

describe Foscam::Model::User do
  before(:each) do
    @user = Foscam::Model::User.new(:id => 1, :name=>"my_username", :pwd=>"my_password", :pri=>"2")
  end
	
	it "sets id as an integer" do
			@user.id.should be_a_kind_of(Fixnum)
	end

	it "sets user name and password as strings" do
		[:name, :pwd].each do |method|
			@user.send(method).should be_a_kind_of(String)
		end
	end

	it "sets user privilages as a USER_PRIVILAGE" do
			@user.privilege.should be_a_kind_of(Symbol)
			::Foscam::Model::User::USER_PERMISSIONS.values.should include(@user.privilege)
	end
	
end