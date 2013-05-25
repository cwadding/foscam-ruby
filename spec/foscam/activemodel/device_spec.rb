require 'spec_helper'

describe Foscam::ActiveModel::Device do

	def valid_params
		{:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"}
	end
	before(:each) do
		@client = ::Foscam::Client.new(valid_params)
		@client.stub(:get_camera_params).and_return({:resolution => "qvga", :brightness => 169, :contrast => 2, :mode => "60hz", :flip => "flip", :fps => 0})
	end

	describe "#client=" do
		before(:each) do
			@device = Foscam::ActiveModel::Device.instance
		end
		it "sets the current Foscam::Client" do
			@device.client = @client
			@device.client.should eql(@client)
		end

		it "sets the camera parameters" do
			@device.client = @client
			@device.resolution.should == "qvga"
			@device.brightness.should == 169
			@device.contrast.should == 2
			# @device.mode.should == "60Hz"
			# @device.orientation.should == "default"
		end
	end

	describe "#capture" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@device = Foscam::ActiveModel::Device.instance
		end
		context "request is successful" do
			it "returns an image" do
				@client.should_receive(:snapshot)
				@device.client = @client
				image = @device.capture
			end
		end
	end


				# def action(value)
				# 	# have an action map to map some subset to the foscam set
				# 	@client.decoder_control(value)
				# end
	describe "#action" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@device = Foscam::ActiveModel::Device.instance
		end
		context "request is successful" do
			before(:each) do
				@client.stub(:decoder_control).and_return(true)
			end
			it "processes the action" do
				@client.should_receive(:decoder_control).with(:up).once
				@device.client = @client
				flag = @device.action(:up)
				flag.should be_true
			end
		end
	end

	describe "#save" do
		before(:each) do
			# @client.stub(:get_params).and_return(one_device_response)
			@device = Foscam::ActiveModel::Device.instance
		end
		context "with valid params" do
			before(:each) do 
				@device.stub(:is_valid?).and_return(true)
			end
			context "is dirty" do
				before(:each) do
					params = {:resolution => "vga", :brightness => 230, :contrast => 3}
					# @device.stub(:changed?).and_return(true)
					@client.should_receive(:camera_control).with(params).once
				end
				context "request is successful" do
					before(:each) do
						@client.stub(:camera_control).and_return(true)
					end
					it "updates the device attributes that changed" do
						@device.client = @client
						@device.brightness = 230
						@device.contrast = 3
						@device.resolution = "vga"
						flag = @device.save
						flag.should be_true
					end
				end
				context "request is unsuccessful" do
					before(:each) do
						@client.stub(:camera_control).and_return(false)
					end
					it "fails to update the device attributes" do
						@device.client = @client
						@device.brightness = 230
						@device.contrast = 3
						@device.resolution = "vga"
						flag = @device.save
						flag.should be_false
					end
				end
			end
			context "is not dirty" do
				before(:each) do
					@device.stub(:changed?).and_return(false)						
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:camera_control)
					@device.client = @client
					flag = @device.save
					flag.should be_false
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@device.stub(:is_valid?).and_return(false)
			end
			it "skips updating since nothing changed" do
				@client.should_not_receive(:camera_control)
				@device.client = @client
				flag = @device.save
				flag.should be_false
			end
		end
	end

end