require 'spec_helper'

describe Foscam::ActiveModel::Network do

	def valid_client_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end

	def default_get_params
		{
			:ip  => "192.168.0.148",
			:mask  => "8.8.8.8",
			:gateway  => "0.0.0.0",
			:dns  => "0.0.0.0",
			:port  => 80
		}
	end

	before(:each) do
		@client = ::Foscam::Client.new(valid_client_params)
		@client.stub(:get_params).and_return(default_get_params)
	end


	describe "#client=" do
		before(:each) do
			@network = Foscam::ActiveModel::Network.instance
		end
		it "sets the current Foscam::Client" do
			@network.client = @client
			@network.client.should eql(@client)
		end

		it "sets the ftp parameters" do
			@network.client = @client
			@network.ip_address.should == default_get_params[:ip]
			@network.mask.should == default_get_params[:mask]
			@network.gateway.should == default_get_params[:gateway]
			@network.dns.should == default_get_params[:dns]
			@network.port.should == default_get_params[:port]
		end
	end

	describe "#save" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@network = Foscam::ActiveModel::Network.instance
		end
		context "with valid params" do
			before(:each) do 
				@network.stub(:is_valid?).and_return(true)
			end
			context "is dirty" do
				context "request is successful" do
					before(:each) do
						params = {			
							:ip  => "192.168.1.3",
							:mask  => "255.255.255.0",
							:gateway  => "192.168.1.1",
							:dns  => "192.168.1.1",
							:port  => 8080
						}
						# @network.stub(:changed?).and_return(true)
						@client.should_receive(:set_network).with(params).once
						@client.stub(:set_network).and_return(true)
					end
					it "updates the ftp attributes that changed" do
						@network.client = @client
						@network.ip_address = "192.168.1.3"
						@network.mask = "255.255.255.0"
						@network.gateway = "192.168.1.1"
						@network.dns = "192.168.1.1"
						@network.port = 8080
						flag = @network.save
						flag.should be_true
					end
				end
				context "request is unsuccessful" do
					before(:each) do
						params = {			
							:ip  => "192.168.1.3",
							:mask  => "255.255.255.0",
							:gateway  => "192.168.1.1",
							:dns  => "192.168.1.1",
							:port  => 8080
						}
						# @network.stub(:changed?).and_return(true)
						@client.should_receive(:set_network).with(params).once
						@client.stub(:set_network).and_return(false)
					end
					it "fails to update the device attributes" do
						@network.client = @client
						@network.ip_address = "192.168.1.3"
						@network.mask = "255.255.255.0"
						@network.gateway = "192.168.1.1"
						@network.dns = "192.168.1.1"
						@network.port = 8080
						flag = @network.save
						flag.should be_false
					end
				end
			end
			context "is not dirty" do
				before(:each) do
					@network.stub(:changed?).and_return(false)						
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_network)
					@network.client = @client
					flag = @network.save
					flag.should be_false
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@network.stub(:is_valid?).and_return(false)
			end
			it "skips updating since nothing changed" do
				@client.should_not_receive(:set_network)
				@network.client = @client
				flag = @network.save
				flag.should be_false
			end
		end
	end

end