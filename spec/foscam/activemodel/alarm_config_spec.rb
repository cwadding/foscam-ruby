require 'spec_helper'

describe Foscam::ActiveModel::AlarmConfig do

	def valid_client_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end

	def default_get_params
		{
        	:alarm_motion_armed => true,
        	:alarm_motion_sensitivity => 0,
        	:alarm_motion_compensation => 0,
        	:alarm_input_armed => true,
        	:alarm_ioin_level => 1,
        	:alarm_iolinkage => 0,
        	:alarm_preset => 0,
        	:alarm_ioout_level => 1,
        	:alarm_mail => false,
        	:alarm_upload_interval => 2,
        	:alarm_http => false,
        	:alarm_msn => false,
        	:alarm_http_url => '',
        	:alarm_schedule_enable => true,
        	:alarm_schedule => Foscam::Schedule::Week.new
		}
	end

	before(:each) do
		@client = ::Foscam::Client.new(valid_client_params)
		@client.stub(:get_params).and_return(default_get_params)
	end


	describe "#client=" do
		before(:each) do
			@alarm = Foscam::ActiveModel::AlarmConfig.instance
		end
		it "sets the current Foscam::Client" do
			@alarm.client = @client
			@alarm.client.should eql(@client)
		end

		it "sets the alarm parameters" do
			@alarm.client = @client
			@alarm.motion_armed.should == default_get_params[:alarm_motion_armed]
			@alarm.motion_sensitivity.should == default_get_params[:alarm_motion_sensitivity]
			@alarm.motion_compensation.should == default_get_params[:alarm_motion_compensation]
			@alarm.input_armed.should == default_get_params[:alarm_input_armed]
			@alarm.ioin_level.should == default_get_params[:alarm_ioin_level]
			@alarm.iolinkage.should == default_get_params[:alarm_iolinkage]
			@alarm.preset.should == default_get_params[:alarm_preset]
			@alarm.ioout_level.should == default_get_params[:alarm_ioout_level]
			@alarm.mail.should == default_get_params[:alarm_mail]
			@alarm.http.should == default_get_params[:alarm_http]
			@alarm.msn.should == default_get_params[:alarm_msn]
			@alarm.http_url.should == default_get_params[:alarm_http_url]
			@alarm.schedule_enable.should == default_get_params[:alarm_schedule_enable]
		end
	end

	describe "#save" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@alarm = Foscam::ActiveModel::AlarmConfig.instance
		end
		context "with valid params" do
			before(:each) do 
				@alarm.stub(:is_valid?).and_return(true)
			end
			context "is dirty" do
				context "request is successful" do
					before(:each) do
						params = {
							:motion_armed => false,
							:motion_sensitivity => 10,
							:motion_compensation => 20,
							:input_armed => false,
							:ioin_level=>1, :iolinkage=>0, :preset=>0, :ioout_level=>1,
							:mail => true,							
							:http => true,
							:msn => true,
							# :http_url => "http://mydomain.com/",
							:schedule_enable => false
						}
						# @alarm.stub(:changed?).and_return(true)
						@client.should_receive(:set_alarm).with(params).once
						@client.stub(:set_alarm).and_return(true)
					end
					it "updates the alarm attributes that changed" do
						@alarm.client = @client
						@alarm.motion_armed = false
						@alarm.motion_sensitivity = 10
						@alarm.motion_compensation = 20
						@alarm.input_armed = false
						@alarm.mail = true
						@alarm.http = true
						@alarm.msn = true
						# @alarm.http_url = "http://mydomain.com/",
						@alarm.schedule_enable = false
						flag = @alarm.save
						flag.should be_true
					end
				end
				context "request is unsuccessful" do
					before(:each) do
						params = {
							:motion_armed => false,
							:motion_sensitivity => 10,
							:motion_compensation => 20,
							:input_armed => false,
							:mail => true,
							# :upload_interval => 5,
							:http => true,
							:msn => true,
							# :http_url => "http://mydomain.com/",
							:schedule_enable => false
						}
						# @alarm.stub(:changed?).and_return(true)
						@client.should_receive(:set_alarm).with(params).once
						@client.stub(:set_alarm).and_return(false)
					end
					it "fails to update the device attributes" do
						@alarm.client = @client
						@alarm.motion_armed = false
						@alarm.motion_sensitivity = 10
						@alarm.motion_compensation = 20
						@alarm.input_armed = false
						@alarm.mail = true
						@alarm.http = true
						@alarm.msn = true
						@alarm.http_url = "http://mydomain.com/",
						@alarm.schedule_enable = false

						flag = @alarm.save
						flag.should be_false
					end
				end
			end
			context "is not dirty" do
				before(:each) do
					@alarm.stub(:changed?).and_return(false)						
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_alarm)
					@alarm.client = @client
					flag = @alarm.save
					flag.should be_false
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@alarm.stub(:is_valid?).and_return(false)
			end
			it "skips updating since nothing changed" do
				@client.should_not_receive(:set_alarm)
				@alarm.client = @client
				flag = @alarm.save
				flag.should be_false
			end
		end
	end
end