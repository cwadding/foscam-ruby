require 'spec_helper'

describe Foscam::Client do 
					
	before(:each) do
		@service = Foscam::Client.new
		@connection = Faraday.new( :url => FOSCAM_URL)
		@connection.basic_auth(FOSCAM_USERNAME, FOSCAM_PASSWORD)
		@service.connection = @connection
	end

	describe "#snapshot" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_snapshot") do
					spec.run
				end
			end
			it "returns an Image" do
				image = @service.snapshot
				image.should be_a_kind_of(MiniMagick::Image)
			end
		end
		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('snapshot.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns nil" do
				image = @service.snapshot
				image.should be_nil
			end
		end
	end

	describe "#get_status" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_get_status") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.get_status
				[:id, :sys_ver, :app_ver, :alias, :now, :tz, :alarm_status, :ddns_status, :ddns_host, :oray_type, :upnp_status, :p2p_status, :p2p_local_port, :msn_status].each do |key|
					response.should have_key(key) 
				end
			end

			it "sets the ddns status string" do
				response = @service.get_status
				response[:ddns_status].should be_a_kind_of(String)
				::Foscam::DDNS_STATUS.values.should include(response[:ddns_status])
			end

			it "sets the upnp status string" do
				response = @service.get_status
				response[:upnp_status].should be_a_kind_of(String)
				::Foscam::UPNP_STATUS.values.should include(response[:upnp_status])
			end

			it "sets the alarm status string" do
				response = @service.get_status
				response[:alarm_status].should be_a_kind_of(String)
				::Foscam::ALARM_STATUS.values.should include(response[:alarm_status])
			end
			it "sets the time" do
				response = @service.get_status
				response[:now].should be_a_kind_of(DateTime)
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('get_status.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.get_status
				response.should == {}
			end
		end
	end

	describe "#get_camera_params" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_get_camera_params") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.get_camera_params
				[:resolution, :brightness, :contrast, :mode, :flip, :fps].each do |key|
					response.should have_key(key) 
				end
			end

			it "sets the mode as a string" do
				response = @service.get_camera_params
				response[:mode].should be_a_kind_of(String)
				::Foscam::CAMERA_PARAMS_MODE.values.should include(response[:mode])
			end
			
			it "sets the orientation as a string" do
				response = @service.get_camera_params
				response[:flip].should be_a_kind_of(String)
				::Foscam::CAMERA_PARAMS_ORIENTATION.values.should include(response[:flip])
			end

			it "sets the resolution as a string" do
				response = @service.get_camera_params
				response[:resolution].should be_a_kind_of(String)
				::Foscam::CAMERA_PARAMS_RESOLUTION.values.should include(response[:resolution])
			end

			it "sets the brightness as a number" do
				response = @service.get_camera_params
				response[:brightness].should be_a_kind_of(Integer)
			end
			it "sets the contrast as a number" do
				response = @service.get_camera_params
				response[:contrast].should be_a_kind_of(Integer)
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('get_camera_params.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.get_camera_params
				response.should == {}
			end
		end
	end

	describe "#decoder_control" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_decoder_control") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				action = :stop_up
				response = @service.decoder_control(action)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('decoder_control.cgi?command=1').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.decoder_control(:stop_up)
				response.should be_false
			end
		end
	end

	describe "#camera_control" do
		describe "camera resolution" do
			context "with valid parameters" do
				around(:each) do |spec|
					::VCR.use_cassette("foscam_camera_control_resolution") do
						spec.run
					end
				end
				it "returns true when set using a string" do
					response = @service.camera_control(:resolution => "QVGA")
					response.should be_true
				end
				it "returns true when set using a number" do
					response = @service.camera_control(:resolution => 8)
					response.should be_true
				end
			end
			context "with invalid parameters" do
				it "raises an exception with invalid number" do
					expect {@service.camera_control(:resolution => 0)}.to raise_error
				end

				it "raises an exception with invalid string" do
					expect {@service.camera_control(:resolution => "XVGA")}.to raise_error
				end
			end
		end

		describe "camera brightness" do
			context "with valid parameters" do
				around(:each) do |spec|
					::VCR.use_cassette("foscam_camera_control_brightness") do
						spec.run
					end
				end
				it "returns true" do
					response = @service.camera_control( :brightness => 160)
					response.should be_true
				end
			end
			context "with invalid parameters" do
				it "raises an exception when < 0" do
					expect {@service.camera_control( :brightness => -1)}.to raise_error
				end

				it "raises an exception when > 255" do
					expect {@service.camera_control( :brightness => 256)}.to raise_error
				end
			end			
		end

		describe "camera contrast" do
			context "with valid parameters" do
				around(:each) do |spec|
					::VCR.use_cassette("foscam_camera_control_contrast") do
						spec.run
					end
				end
				it "returns true" do
					response = @service.camera_control(:contrast => 4)
					response.should be_true
				end
			end
			context "with invalid parameters" do
				it "raises an exception when < 0" do
					expect {@service.camera_control( :contrast => -1)}.to raise_error
				end

				it "raises an exception when > 6" do
					expect {@service.camera_control( :contrast => 7)}.to raise_error
				end
			end
		end

		describe "camera mode" do
			context "with valid parameters" do
				around(:each) do |spec|
					::VCR.use_cassette("foscam_camera_control_mode") do
						spec.run
					end
				end
				it "returns true" do
					response = @service.camera_control( :mode => :outdoor)
					response.should be_true
				end
			end
			context "with invalid parameters" do
				it "raises an exception when < 0" do
					expect {@service.camera_control( :mode => -1)}.to raise_error
				end

				it "raises an exception when > 2" do
					expect {@service.camera_control( :mode => 3)}.to raise_error
				end
				it "raises an exception with an invalid string" do
					expect {@service.camera_control( :mode => "10Hz")}.to raise_error
				end
			end
		end

		describe "camera orientation" do
			context "with valid parameters" do
				around(:each) do |spec|
					::VCR.use_cassette("foscam_camera_control_orientation") do
						spec.run
					end
				end
				it "returns true" do
					response = @service.camera_control(:flip => "mirror")
					response.should be_true
				end
			end
			context "with invalid parameters" do
				it "raises an exception when < 0" do
					expect {@service.camera_control(:flip => -1)}.to raise_error
				end

				it "raises an exception when > 3" do
					expect {@service.camera_control(:flip => 4)}.to raise_error
				end
				it "raises an exception with an invalid string" do
					expect {@service.camera_control( :mode => "diagonal")}.to raise_error
				end
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('camera_control.cgi?param=1&value=160').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.camera_control(:brightness => 160)
				response.should be_false
			end
		end


	end

	describe "#reboot" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_reboot") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.reboot
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('reboot.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.reboot
				response.should be_false
			end
		end
	end

	describe "#restore_factory" do

		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_restore_factory") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.restore_factory
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('restore_factory.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.restore_factory
				response.should be_false
			end
		end
	end

	describe "#get_params" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_get_params") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.get_params
				[	:id, :sys_ver, :app_ver, :alias, 
					:now, :tz, :daylight_saving_time, :ntp_enable, :ntp_svr, 
					:user1_name, :user1_pwd, :user1_pri, 
					:user2_name, :user2_pwd, :user2_pri, 
					:user3_name, :user3_pwd, :user3_pri, 
					:user4_name, :user4_pwd, :user4_pri, 
					:user5_name, :user5_pwd, :user5_pri, 
					:user6_name, :user6_pwd, :user6_pri, 
					:user7_name, :user7_pwd, :user7_pri, 
					:user8_name, :user8_pwd, :user8_pri, 
					:dev2_alias, :dev2_host, :dev2_port, :dev2_user, :dev2_pwd, 
					:dev3_alias, :dev3_host, :dev3_port, :dev3_user, :dev3_pwd, 
					:dev4_alias, :dev4_host, :dev4_port, :dev4_user, :dev4_pwd, 
					:dev5_alias, :dev5_host, :dev5_port, :dev5_user, :dev5_pwd, 
					:dev6_alias, :dev6_host, :dev6_port, :dev6_user, :dev6_pwd, 
					:dev7_alias, :dev7_host, :dev7_port, :dev7_user, :dev7_pwd, 
					:dev8_alias, :dev8_host, :dev8_port, :dev8_user, :dev8_pwd, 
					:dev9_alias, :dev9_host, :dev9_port, :dev9_user, :dev9_pwd, 
					:ip, :mask, :gateway, :dns, :port, 
					:wifi_enable, :wifi_ssid, :wifi_encrypt, :wifi_defkey, 
					:wifi_key1, :wifi_key2, :wifi_key3, :wifi_key4, :wifi_authtype, :wifi_keyformat, 
					:wifi_key1_bits, :wifi_key2_bits, :wifi_key3_bits, :wifi_key4_bits, :wifi_mode, :wifi_wpa_psk, 
					:pppoe_enable, :pppoe_user, :pppoe_pwd, :upnp_enable, 
					:ddns_service, :ddns_user, :ddns_pwd, :ddns_host, :ddns_proxy_svr, :ddns_proxy_port, 
					:mail_svr, :mail_port, :mail_tls, :mail_user, :mail_pwd, :mail_sender, 
					:mail_receiver1, :mail_receiver2, :mail_receiver3, :mail_receiver4, :mail_inet_ip, 
					:ftp_svr, :ftp_port, :ftp_user, :ftp_pwd, :ftp_dir, :ftp_mode, :ftp_upload_interval, :ftp_filename, :ftp_numberoffiles, :ftp_schedule_enable, 
					:ftp_schedule_sun_0, :ftp_schedule_sun_1, :ftp_schedule_sun_2, 
					:ftp_schedule_mon_0, :ftp_schedule_mon_1, :ftp_schedule_mon_2, 
					:ftp_schedule_tue_0, :ftp_schedule_tue_1, :ftp_schedule_tue_2, 
					:ftp_schedule_wed_0, :ftp_schedule_wed_1, :ftp_schedule_wed_2, 
					:ftp_schedule_thu_0, :ftp_schedule_thu_1, :ftp_schedule_thu_2, 
					:ftp_schedule_fri_0, :ftp_schedule_fri_1, :ftp_schedule_fri_2, 
					:ftp_schedule_sat_0, :ftp_schedule_sat_1, :ftp_schedule_sat_2, 
					:alarm_motion_armed, :alarm_motion_sensitivity, :alarm_motion_compensation, 
					:alarm_input_armed, :alarm_ioin_level, :alarm_iolinkage, :alarm_preset, :alarm_ioout_level, :alarm_mail, :alarm_upload_interval, :alarm_http, :alarm_msn, :alarm_http_url, :alarm_schedule_enable, 
					:alarm_schedule_sun_0, :alarm_schedule_sun_1, :alarm_schedule_sun_2, 
					:alarm_schedule_mon_0, :alarm_schedule_mon_1, :alarm_schedule_mon_2, 
					:alarm_schedule_tue_0, :alarm_schedule_tue_1, :alarm_schedule_tue_2, 
					:alarm_schedule_wed_0, :alarm_schedule_wed_1, :alarm_schedule_wed_2, 
					:alarm_schedule_thu_0, :alarm_schedule_thu_1, :alarm_schedule_thu_2, 
					:alarm_schedule_fri_0, :alarm_schedule_fri_1, :alarm_schedule_fri_2, 
					:alarm_schedule_sat_0, :alarm_schedule_sat_1, :alarm_schedule_sat_2, 
					:decoder_baud, :msn_user, :msn_pwd, 
					:msn_friend1, :msn_friend2, :msn_friend3, :msn_friend4, :msn_friend5, :msn_friend6, :msn_friend7, :msn_friend8, :msn_friend9, :msn_friend10
				].each do |key|
					response.should have_key(key) 
				end
			end
			it "sets now as datetime" do
				response = @service.get_params
				response[:now].should be_a_kind_of(DateTime)
			end
			it "sets the daylight_savings_time as a number" do
				response = @service.get_params
				response[:daylight_savings_time].should be_a_kind_of(Integer)
			end
			it "sets ntp_enable as a Boolean" do
				response = @service.get_params
				response[:ntp_enable].should be_a_kind_of(Boolean)
			end

			it "sets user privilages as a USER_PRIVILAGE" do
				response = @service.get_params
				[:user1_pri, :user2_pri, :user3_pri, :user4_pri, :user5_pri, :user6_pri, :user7_pri, :user8_pri].each do |key|
					response[key].should be_a_kind_of(Symbol)
					::Foscam::USER_PERMISSIONS.values.should include(response[key])
				end
			end

			it "sets the ports as a number" do
				response = @service.get_params
				[:ddns_proxy_port, :ftp_port, :mail_port, :port, :dev2_port, :dev3_port, :dev4_port, :dev5_port, :dev6_port, :dev7_port, :dev8_port, :dev9_port].each do |key|
					response[key].should be_a_kind_of(Integer)
				end
			end

			it "sets wifi_enable as a boolean" do
				response = @service.get_params
				response[:wifi_enable].should be_a_kind_of(Boolean)
			end

			it "sets pppoe_enable as a boolean" do
				response = @service.get_params
				response[:pppoe_enable].should be_a_kind_of(Boolean)
			end
			it "sets upnp_enable as a boolean" do
				response = @service.get_params
				response[:upnp_enable].should be_a_kind_of(Boolean)
			end

			it "sets alarm_schedule_enable as a boolean" do
				response = @service.get_params
				response[:alarm_schedule_enable].should be_a_kind_of(Boolean)
			end

			it "sets ftp_schedule_enable as a boolean" do
				response = @service.get_params
				response[:ftp_schedule_enable].should be_a_kind_of(Boolean)
			end

			it "sets the ftp_schedule as an integer" do
				response = @service.get_params
				[	
					:ftp_schedule_sun_0, :ftp_schedule_sun_1, :ftp_schedule_sun_2, 
					:ftp_schedule_mon_0, :ftp_schedule_mon_1, :ftp_schedule_mon_2, 
					:ftp_schedule_tue_0, :ftp_schedule_tue_1, :ftp_schedule_tue_2, 
					:ftp_schedule_wed_0, :ftp_schedule_wed_1, :ftp_schedule_wed_2, 
					:ftp_schedule_thu_0, :ftp_schedule_thu_1, :ftp_schedule_thu_2, 
					:ftp_schedule_fri_0, :ftp_schedule_fri_1, :ftp_schedule_fri_2, 
					:ftp_schedule_sat_0, :ftp_schedule_sat_1, :ftp_schedule_sat_2
				].each do |key|
					response[key].should be_a_kind_of(Integer)
				end
			end

			it "sets the alarm_schedule as an integer" do
				response = @service.get_params
				[	
					:alarm_schedule_sun_0, :alarm_schedule_sun_1, :alarm_schedule_sun_2, 
					:alarm_schedule_mon_0, :alarm_schedule_mon_1, :alarm_schedule_mon_2, 
					:alarm_schedule_tue_0, :alarm_schedule_tue_1, :alarm_schedule_tue_2, 
					:alarm_schedule_wed_0, :alarm_schedule_wed_1, :alarm_schedule_wed_2, 
					:alarm_schedule_thu_0, :alarm_schedule_thu_1, :alarm_schedule_thu_2, 
					:alarm_schedule_fri_0, :alarm_schedule_fri_1, :alarm_schedule_fri_2, 
					:alarm_schedule_sat_0, :alarm_schedule_sat_1, :alarm_schedule_sat_2
				].each do |key|
					response[key].should be_a_kind_of(Integer)
				end
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('get_params.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.get_params
				response.should == {}
			end
		end
	end

	# describe "#upgrade_firmware" do
	# 	around(:each) do |spec|
	# 		::VCR.use_cassette("foscam_upgrade_firmware") do
	# 			spec.run
	# 		end
	# 	end
	# 	it "" do
	# 		@service.upgrade_firmware
	# 	end

	# end

	# describe "#upgrade_htmls" do
	# 	around(:each) do |spec|
	# 		VCR.use_cassette("foscam_upgrade_htmls") do
	# 			spec.run
	# 		end
	# 	end
	# 	it "" do
	# 		@service.upgrade_htmls
	# 	end
		
	# end

	describe "#set_alias" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_alias") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				name = "R2D2"
				response = @service.set_alias(name)
				response.should be_true
			end
		end
		context "with invalid parameters" do
			it "raises an exception when more than 20 characters long 0" do
				expect {@service.set_alias("123456789012345678901")}.to raise_error
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_alias.cgi?alias=R2D2').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				name = "R2D2"
				response = @service.set_alias(name)
				response.should be_false
			end
		end
	end

	describe "#set_datetime" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_datetime") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:tz =>18000, :ntp_enable => 1, :ntp_svr => "0.ca.pool.ntp.org"}
				response = @service.set_datetime(params)
				response.should be_true
			end
		end

		context "with invalid parameters" do
			it "raises an exception when ntp_server more than 64 characters long" do
				expect {@service.set_datetime(:ntp_svr => "012345678901234567890123456789012345678901234567890123456789012345")}.to raise_error
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_datetime.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_datetime({})
				response.should be_false
			end
		end

	end

	describe "#set_users" do
		context "with valid parameters" do
			it "sets user 2 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user2") do
					params = {:user2 => "user2", :pwd2 => "pass2", :pri2 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 3 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user3") do
					params = {:user3 => "user3", :pwd3 => "pass3", :pri3 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 4 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user4") do
					params = {:user4 => "user4", :pwd4 => "pass4", :pri4 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 5 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user5") do
					params = {:user5 => "user5", :pwd4 => "pass5", :pri5 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 6 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user6") do
					params = {:user6 => "user6", :pwd6 => "pass6", :pri6 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 7 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user7") do
					params = {:user7 => "user7", :pwd7 => "pass7", :pri7 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end

			it "sets user 8 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user8") do
					params = {:user8 => "user8", :pwd7 => "pass8", :pri8 => 0}
					response = @service.set_users(params)
					response.should be_true
				end
			end		
		end

		context "with invalid parameters" do
			it "raises an exception when username or password is more than 12 characters long" do
				[:user1, :pwd1, :user2, :pwd2, :user3, :pwd3, :user4, :pwd4, :user5, :pwd5, :user6, :pwd6, :user7, :pwd7, :user8, :pwd8].each do |key|
					expect {@service.set_users(key => "0123456789123")}.to raise_error
				end
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_users.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_users({})
				response.should be_false
			end
		end

	end

	# describe "#set_devices" do
	# 	around(:each) do |spec|
	# 		VCR.use_cassette("foscam_set_devices") do
	# 			spec.run
	# 		end
	# 	end
	# 	it "" do
	# 		@service.set_devices(params)
	# 	end

	# end

	describe "#set_network" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_network") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:ip => "192.168.0.100", :mask => "0.0.0.0", :gateway => "0.0.0.0", :dns => "8.8.8.8", :port => "8080"}
				response = @service.set_network(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_network.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				params = {}
				response = @service.set_network(params)
				response.should be_false
			end
		end
	end

	describe "#set_wifi" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_wifi") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:ssid => "my_wireless_ssid", :enable => 1, :encrypt => 1, :wpa_psk => "my_wireless_password"}
				response = @service.set_wifi(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_wifi.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				params = {}
				response = @service.set_wifi(params)
				response.should be_false
			end
		end


	end

	describe "#set_pppoe" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_pppoe") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:enable => 1, :user => "root", :pwd => "pass"}
				response = @service.set_pppoe(params)
				response.should be_true
			end
		end
		context "with invalid parameters" do
			it "raises an exception when username is more than 40 characters long" do
				expect {@service.set_pppoe(:user => "01234567890123456789012345678901234567891")}.to raise_error
			end
			it "raises an exception when password is more than 20 characters long" do
				expect {@service.set_pppoe(:pwd => "012345678901234567890")}.to raise_error
			end
		end
		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_pppoe.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				params = {}
				response = @service.set_pppoe(params)
				response.should be_false
			end
		end
	end

	describe "#set_upnp" do	
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_upnp") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.set_upnp(1)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_upnp.cgi?enable=1').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_upnp(1)
				response.should be_false
			end
		end

	end

	describe "#set_ddns" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_ddns") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:service => 3, :user => "root", :pwd => "password", :host => "hostname.dyndns.com"}
				response = @service.set_ddns(params)
				response.should be_true
			end
		end
		context "with invalid parameters" do
			it "raises an exception when username is more than 20 characters long" do
				expect {@service.set_ddns(:user => "012345678901234567890")}.to raise_error
			end
			it "raises an exception when password is more than 20 characters long" do
				expect {@service.set_ddns(:pwd => "012345678901234567890")}.to raise_error
			end
			it "raises an exception when proxy_svr is more than 20 characters long" do
				expect {@service.set_ddns(:proxy_svr => "012345678901234567890")}.to raise_error
			end
			it "raises an exception when host is more than 40 characters long" do
				expect {@service.set_ddns(:host => "01234567890123456789012345678901234567890")}.to raise_error
			end
		end
		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_ddns.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_ddns({})
				response.should be_false
			end
		end
	end

	describe "#set_ftp" do

		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_ftp") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:svr => "192.168.0.116", :port => 21, :user => "my_username", :pwd =>"my_password", :dir => "R2D2", :upload_interval => 3600}
				response = @service.set_ftp(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_ftp.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_ftp({})
				response.should be_false
			end
		end
	end

	describe "#set_mail" do

		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_mail") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:svr => "smtp.gmail.com", :port => 465, :user => "username@gmail.com", :pwd =>"password", :sender => "sender@gmail.com", :receiver1 => "receiver@gmail.com"}
				response = @service.set_mail(params)
				response.should be_true
			end
		end
		context "with invalid parameters" do
			it "raises an exception when username is more than 20 characters long" do
				expect {@service.set_mail(:user => "012345678901234567890")}.to raise_error
			end
			it "raises an exception when password is more than 20 characters long" do
				expect {@service.set_mail(:pwd => "012345678901234567890")}.to raise_error
			end
		end
		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_mail.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_mail({})
				response.should be_false
			end
		end

	end

	describe "#set_alarm" do

		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_alarm") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:motion_armed => 0, :motion_sensitivity => 3, :input_armed => 0, :iolinkage => 0, :mail => 0, :upload_interval => 0}
				response = @service.set_alarm(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_alarm.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_alarm({})
				response.should be_false
			end
		end

	end

	describe "#comm_write" do

		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_comm_write") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {:port => 0, :baud => 15, :bytes => "dsfds", :data => "url_code"}
				response = @service.comm_write(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('comm_write.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.comm_write({})
				response.should be_false
			end
		end

	end

	describe "#set_forbidden" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_forbidden") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				params = {
					:schedule_sun_0 => 95, :schedule_sun_1 => 45, :schedule_sun_2 => 20,
					:schedule_mon_0 => 95, :schedule_mon_1 => 45, :schedule_mon_2 => 20,
					:schedule_tue_0 => 95, :schedule_tue_1 => 45, :schedule_tue_2 => 20,
					:schedule_wed_0 => 95, :schedule_wed_1 => 45, :schedule_wed_2 => 20,
					:schedule_thu_0 => 95, :schedule_thu_1 => 45, :schedule_thu_2 => 20,
					:schedule_fri_0 => 95, :schedule_fri_1 => 45, :schedule_fri_2 => 20,
					:schedule_sat_0 => 95, :schedule_sat_1 => 45, :schedule_sat_2 => 20
				}
				response = @service.set_forbidden(params)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_forbidden.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_forbidden({})
				response.should be_false
			end
		end
	end

	describe "#get_forbidden" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_get_forbidden") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.get_forbidden
				[	:schedule_sun_0, :schedule_sun_1, :schedule_sun_2,
					:schedule_mon_0, :schedule_mon_1, :schedule_mon_2,
					:schedule_tue_0, :schedule_tue_1, :schedule_tue_2,
					:schedule_wed_0, :schedule_wed_1, :schedule_wed_2,
					:schedule_thu_0, :schedule_thu_1, :schedule_thu_2,
					:schedule_fri_0, :schedule_fri_1, :schedule_fri_2,
					:schedule_sat_0, :schedule_sat_1, :schedule_sat_2
				].each do |key|
					response.should have_key(key) 
				end
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('get_forbidden.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.get_forbidden
				response.should == {}
			end
		end
	end

	describe "#set_misc" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_misc") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				@params = {
					:led_mode => :mode1,
					:ptz_center_onstart =>  false, 
					:ptz_auto_patrol_interval => 5, 
					:ptz_auto_patrol_type => :vertical, 
					:ptz_patrol_h_rounds => 1, 
					:ptz_patrol_v_rounds => 1, 
					:ptz_patrol_rate => 20, 
					:ptz_patrol_up_rate => 10, 
					:ptz_patrol_down_rate => 10, 
					:ptz_patrol_left_rate => 10, 
					:ptz_patrol_right_rate => 10, 
					:ptz_disable_preset => false, 
					:ptz_preset_onstart => true
				}
				response = @service.set_misc(@params)
				response.should be_true
				response = @service.get_misc
				@params.each do |key, value|
					response[key].should == value
				end
			end
		end
		
		context "with invalid parameters" do
			it "raises an exception when patrol rates are > 100" do
				[:ptz_patrol_rate, :ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate].each do |key|
					expect {@service.set_misc(key => 101)}.to raise_error
				end
			end
			it "raises an exception when patrol rates and rounds are < 0" do
				[:ptz_auto_patrol_interval, :ptz_patrol_h_rounds, :ptz_patrol_v_rounds, :ptz_patrol_rate, :ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate].each do |key|
					expect {@service.set_misc(key => -1)}.to raise_error
				end
			end

			it "raises an exception when password is more than 20 characters long" do
				expect {@service.set_misc(:pwd => "012345678901234567890")}.to raise_error
			end

			it "raises an exception if there is no match for the led_mode" do
				expect {@service.set_misc(:led_mode => :mode5)}.to raise_error
			end

			it "raises an exception if there is no match for the ptz_auto_patrol_type" do
				expect {@service.set_misc(:ptz_auto_patrol_type => :vert)}.to raise_error
			end

		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_misc.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_misc({})
				response.should be_false
			end
		end
	end

	describe "#get_misc" do
		context "response is successful" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_get_misc") do
					spec.run
				end
			end
			it "returns a hash of variables" do
				response = @service.get_misc
				[:led_mode, :ptz_center_onstart, :ptz_auto_patrol_interval, :ptz_auto_patrol_type, :ptz_patrol_h_rounds, :ptz_patrol_v_rounds, :ptz_patrol_rate, :ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate, :ptz_disable_preset, :ptz_preset_onstart].each do |key|
					response.should have_key(key) 
				end
			end

			it "sets onstart fields as a boolean" do
				response = @service.get_misc
				[:ptz_disable_preset, :ptz_preset_onstart, :ptz_center_onstart].each do |key|
					response[key].should be_a_kind_of(Boolean)
				end
			end

			it "sets the patrol round, rates, and intervals as an integer" do
				response = @service.get_misc
				[
					:ptz_auto_patrol_interval, :ptz_patrol_h_rounds, :ptz_patrol_v_rounds, :ptz_patrol_rate, 
					:ptz_patrol_up_rate, :ptz_patrol_down_rate, :ptz_patrol_left_rate, :ptz_patrol_right_rate
				].each do |key|
					response[key].should be_a_kind_of(Integer)
				end
			end

			it "sets the led_mode as a symbol" do
				response = @service.get_misc
				response[:led_mode].should be_a_kind_of(Symbol)
				::Foscam::LED_MODE.values.should include(response[:led_mode])
			end

			it "sets the ptz_auto_patrol_type as a symbol" do
				response = @service.get_misc
				response[:ptz_auto_patrol_type].should be_a_kind_of(Symbol)
				::Foscam::PTZ_AUTO_PATROL_TYPE.values.should include(response[:ptz_auto_patrol_type])
			end

		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('get_misc.cgi').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.get_misc
				response.should == {}
			end
		end
	end

	describe "#set_decoder" do
		context "with valid parameters" do
			around(:each) do |spec|
				# @service.connection = @connection
				::VCR.use_cassette("foscam_set_decoder") do
					spec.run
				end
			end
			it "sets the baud with an integer" do
				baud = 9
				response = @service.set_decoder(baud)
				response.should be_true
			end

			it "sets the baud with a symbol" do
				baud = :B1200
				response = @service.set_decoder(baud)
				response.should be_true
			end

			it "sets the baud with a string" do
				baud = "B1200"
				response = @service.set_decoder(baud)
				response.should be_true
			end
		end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_decoder.cgi?baud=9').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_decoder(9)
				response.should be_false
			end
		end
	end

end