require 'spec_helper'

describe Foscam::Model::FtpServer do

	def valid_client_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end

	def default_get_params
		{
			:ftp_svr  => "192.168.0.148",
			:ftp_port  => 21,
			:ftp_user  => "foobar",
			:ftp_pwd  => "secret",
			:ftp_dir  => "foscam",
			:ftp_mode  => 1,
			:ftp_upload_interval  => 0,
			:ftp_filename  => "",
			:ftp_numberoffiles => 5,
			:ftp_schedule_enable => false,
			:ftp_schedule_sun_0 => 0,
			:ftp_schedule_sun_1 => 0,
			:ftp_schedule_sun_2 => 0,
			:ftp_schedule_mon_0 => 0,
			:ftp_schedule_mon_1 => 0,
			:ftp_schedule_mon_2 => 0,
			:ftp_schedule_tue_0 => 0,
			:ftp_schedule_tue_1 => 0,
			:ftp_schedule_tue_2 => 0,
			:ftp_schedule_wed_0 => 0,
			:ftp_schedule_wed_1 => 0,
			:ftp_schedule_wed_2 => 0,
			:ftp_schedule_thu_0 => 0,
			:ftp_schedule_thu_1 => 0,
			:ftp_schedule_thu_2 => 0,
			:ftp_schedule_fri_0 => 0,
			:ftp_schedule_fri_1 => 0,
			:ftp_schedule_fri_2 => 0,
			:ftp_schedule_sat_0 => 0,
			:ftp_schedule_sat_1 => 0,
			:ftp_schedule_sat_2 => 0
		}
	end

	before(:each) do
		@client = ::Foscam::Client.new(valid_client_params)
		@client.stub(:get_params).and_return(default_get_params)
	end


	describe "#client=" do
		before(:each) do
			@ftp = Foscam::Model::FtpServer.instance
		end
		it "sets the current Foscam::Client" do
			@ftp.client = @client
			@ftp.client.should eql(@client)
		end

		it "sets the ftp parameters" do
			@ftp.client = @client
			@ftp.dir.should == default_get_params[:ftp_dir]
			@ftp.address.should == default_get_params[:ftp_svr]
			@ftp.port.should == default_get_params[:ftp_port]
			@ftp.username.should == default_get_params[:ftp_user]
			@ftp.password.should == default_get_params[:ftp_pwd]
			@ftp.upload_interval.should == default_get_params[:ftp_upload_interval]
		end
	end

	describe "#save" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@ftp = Foscam::Model::FtpServer.instance
		end
		context "with valid params" do
			before(:each) do 
				@ftp.stub(:is_valid?).and_return(true)
			end
			context "is dirty" do
				context "request is successful" do
					before(:each) do
						params = {:dir => "path/root/", :user => "foobar1", :pwd => "secret1", :svr => "192.168.0.2", :port => 21,:upload_interval => 0}
						# @ftp.stub(:changed?).and_return(true)
						@client.should_receive(:set_ftp).with(params).once
						@client.stub(:set_ftp).and_return(true)
					end
					it "updates the ftp attributes that changed" do
						@ftp.client = @client
						@ftp.username = "foobar1"
						@ftp.password = "secret1"
						@ftp.dir = "path/root/"
						@ftp.address = "192.168.0.2"
						flag = @ftp.save
						flag.should be_true
					end
				end
				context "request is unsuccessful" do
					before(:each) do
						params = {:dir => "path/root/", :user => "foobar1", :pwd => "secret1", :svr => "192.168.0.2"}
						# @ftp.stub(:changed?).and_return(true)
						@client.should_receive(:set_ftp).with(params).once
						@client.stub(:set_ftp).and_return(false)
					end
					it "fails to update the device attributes" do
						@ftp.client = @client
						@ftp.username = "foobar1"
						@ftp.password = "secret1"
						@ftp.dir = "path/root/"
						@ftp.address = "192.168.0.2"
						flag = @ftp.save
						flag.should be_false
					end
				end
			end
			context "is not dirty" do
				before(:each) do
					@ftp.stub(:changed?).and_return(false)						
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_ftp)
					@ftp.client = @client
					flag = @ftp.save
					flag.should be_false
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@ftp.stub(:is_valid?).and_return(false)
			end
			it "skips updating since nothing changed" do
				@client.should_not_receive(:set_ftp)
				@ftp.client = @client
				flag = @ftp.save
				flag.should be_false
			end
		end
	end

	describe "#clear" do
		before(:each) do
			@ftp = Foscam::Model::FtpServer.instance
		end			
		it "should save the user with blank usernames, password and privileges" do
			params = {:dir => "", :user => "", :pwd => "", :svr => "", :port => 21, :upload_interval => 0}
			@client.stub(:set_ftp).with(params).and_return(true)
			@client.should_receive(:set_ftp).with(params).once
			@ftp.client = @client
			flag = @ftp.clear
			flag.should be_true
		end
	end	

end