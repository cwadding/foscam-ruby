require 'spec_helper'

describe Foscam::Model::Base do

	def valid_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end

	describe "#connect" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@device = Foscam::Model::Base.new
		end
		it "returns an instance of a Foscam::Client" do
			client = @device.connect(valid_params)
			client.should be_an_instance_of(::Foscam::Client)
			client.username.should == valid_params[:username]
			client.url.should == valid_params[:url]
			client.password.should == valid_params[:password]
		end
	end
end