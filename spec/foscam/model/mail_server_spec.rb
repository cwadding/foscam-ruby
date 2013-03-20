require 'spec_helper'

describe Foscam::Model::MailServer do

	def valid_client_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end

	def default_get_params
		{
			:mail_svr  => "192.168.0.148",
			:mail_port  => 21,
			:mail_user  => "foobar",
			:mail_pwd  => "secret",
			:mail_sender  => "foscam"
		}
	end

	before(:each) do
		@client = ::Foscam::Client.new(valid_client_params)
		@client.stub(:get_params).and_return(default_get_params)
	end


	describe "#connect" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@mail = Foscam::Model::MailServer.instance
		end
		it "returns an instance of a Foscam::Client" do
			client = @mail.connect(valid_client_params)
			client.should be_an_instance_of(::Foscam::Client)
			client.username.should == valid_client_params[:username]
			client.url.should == valid_client_params[:url]
			client.password.should == valid_client_params[:password]
		end
	end

	describe "#client=" do
		before(:each) do
			@mail = Foscam::Model::MailServer.instance
		end
		it "sets the current Foscam::Client" do
			@mail.client = @client
			@mail.client.should eql(@client)
		end

		it "sets the mail parameters" do
			@mail.client = @client
			@mail.sender.should == default_get_params[:mail_sender]
			@mail.address.should == default_get_params[:mail_svr]
			@mail.port.should == default_get_params[:mail_port]
			@mail.username.should == default_get_params[:mail_user]
			@mail.password.should == default_get_params[:mail_pwd]
		end
	end

	describe "#save" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@mail = Foscam::Model::MailServer.instance
		end
		context "with valid params" do
			before(:each) do 
				@mail.stub(:is_valid?).and_return(true)
			end
			context "is dirty" do

				context "request is successful" do
					before(:each) do
						params = {:sender => "foo@bar.com", :user => "foobar1", :pwd => "secret1", :svr => "192.168.0.2", :port => 21}
						@client.should_receive(:set_mail).with(params).once
						@client.stub(:set_mail).and_return(true)
					end
					it "updates the mail attributes that changed" do
						@mail.client = @client
						@mail.username = "foobar1"
						@mail.password = "secret1"
						@mail.sender = "foo@bar.com"
						@mail.address = "192.168.0.2"
						flag = @mail.save
						flag.should be_true
					end
				end
				context "request is unsuccessful" do
					before(:each) do
						params = {:sender => "foo@bar.com", :user => "foobar1", :pwd => "secret1", :svr => "192.168.0.2"}
						@client.should_receive(:set_mail).with(params).once						
						@client.stub(:set_mail).and_return(false)
					end
					it "fails to update the device attributes" do
						@mail.client = @client
						@mail.username = "foobar1"
						@mail.password = "secret1"
						@mail.sender = "foo@bar.com"
						@mail.address = "192.168.0.2"
						flag = @mail.save
						flag.should be_false
					end
				end
			end
			context "is not dirty" do
				before(:each) do
					@mail.stub(:changed?).and_return(false)						
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_mail)
					@mail.client = @client
					flag = @mail.save
					flag.should be_false
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@mail.stub(:is_valid?).and_return(false)
			end
			it "skips updating since nothing changed" do
				@client.should_not_receive(:set_mail)
				@mail.client = @client
				flag = @mail.save
				flag.should be_false
			end
		end
	end

	describe "#clear" do
		before(:each) do
			@mail = Foscam::Model::MailServer.instance
		end			
		it "should save the user with blank usernames, password and privileges" do
			params = {:sender => "", :user => "", :pwd => "", :svr => "", :port => 21, :receiver1 => "", :receiver2 => "", :receiver3 => "", :receiver4 => ""}
			@client.stub(:set_mail).with(params).and_return(true)
			@client.should_receive(:set_mail).with(params).once
			@mail.client = @client
			flag = @mail.clear
			flag.should be_true
		end
	end	

end