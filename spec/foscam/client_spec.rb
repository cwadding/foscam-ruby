require 'spec_helper'

describe Foscam::Client do 
					
	before(:each) do
		@service = Foscam::Client.new
		@connection = Faraday.new( :url => FOSCAM_URL)
		@connection.basic_auth(FOSCAM_USERNAME, FOSCAM_PASSWORD)
		@service.connection = @connection
	end

  describe "#group_params" do
    before(:each) do
      @params = {
        :id => "000DC5D4DC51", :sys_ver => "11.22.2.38", :app_ver => "2.4.18.17", :alias => "R2D2", :now => "1352782970", :tz => "18000", :daylight_saving_time => "0",
        :ntp_enable=>"1", :ntp_svr => "0.ca.pool.ntp.org",
        :user1_name => "my_username", :user1_pwd => "my_password", :user1_pri=>"2",
        :user2_name => "test", :user2_pwd => "test", :user2_pri => "1", 
        :user3_name => "", :user3_pwd => "", :user3_pri => "0",
        :user4_name => "", :user4_pwd => "", :user4_pri => "0",
        :user5_name => "", :user5_pwd => "", :user5_pri => "0",
        :user6_name => "", :user6_pwd => "", :user6_pri => "0",
        :user7_name => "", :user7_pwd => "", :user7_pri => "0",
        :user8_name => "", :user8_pwd => "", :user8_pri => "0",
        :dev2_alias => "", :dev2_host => "", :dev2_port => "0", :dev2_user => "", :dev2_pwd => "",
        :dev3_alias => "", :dev3_host => "", :dev3_port => "0", :dev3_user => "", :dev3_pwd => "",
        :dev4_alias => "", :dev4_host => "", :dev4_port => "0", :dev4_user => "", :dev4_pwd => "",
        :dev5_alias => "", :dev5_host => "", :dev5_port => "0", :dev5_user => "", :dev5_pwd => "",
        :dev6_alias => "", :dev6_host => "", :dev6_port => "0", :dev6_user => "", :dev6_pwd => "",
        :dev7_alias => "", :dev7_host => "", :dev7_port => "0", :dev7_user => "", :dev7_pwd => "",
        :dev8_alias => "", :dev8_host => "", :dev8_port => "0", :dev8_user => "", :dev8_pwd => "",
        :dev9_alias => "", :dev9_host => "", :dev9_port => "0", :dev9_user => "", :dev9_pwd => "",
        :ip => "0.0.0.0", :mask => "0.0.0.0", :gateway => "0.0.0.0", :dns => "0.0.0.0", :port => "80", :wifi_ssid => "my_wireless_ssid",
        :wifi_enable => "1", :wifi_encrypt => "3", :wifi_defkey => "0", :wifi_key1 => "", :wifi_key2 => "", :wifi_key3 => "", :wifi_key4 => "", :wifi_authtype => "0", :wifi_keyformat => "0", :wifi_key1_bits => "0", :wifi_key2_bits => "0", :wifi_key3_bits => "0", :wifi_key4_bits => "0", :wifi_mode => "0", :wifi_wpa_psk => "my_wireless_password",
        :pppoe_enable => "0", :pppoe_user => "", :pppoe_pwd => "", :upnp_enable => "0", 
        :ddns_service => "0", :ddns_user => "", :ddns_pwd=>"", :ddns_host=>"", :ddns_proxy_svr=>"", :ddns_proxy_port=>"0", 
        :mail_svr=>"", :mail_port=>"0", :mail_tls=>"0", :mail_user=>"", :mail_pwd=>"", :mail_sender=>"", :mail_receiver1=>"", :mail_receiver2=>"", :mail_receiver3=>"", :mail_receiver4=>"", :mail_inet_ip=>"0", 
        :ftp_svr=>"192.168.0.148", :ftp_port=>"21", :ftp_user=>"my_username", :ftp_pwd=>"secret", :ftp_dir=>"R2D2", :ftp_mode=>"1", :ftp_upload_interval=>"0", :ftp_filename=>"", :ftp_numberoffiles=>"0", 
        :ftp_schedule_enable=>"0", :ftp_schedule_sun_0=>"0", :ftp_schedule_sun_1=>"0", :ftp_schedule_sun_2=>"0", :ftp_schedule_mon_0=>"0", :ftp_schedule_mon_1=>"0", :ftp_schedule_mon_2=>"0", :ftp_schedule_tue_0=>"0", :ftp_schedule_tue_1=>"0", :ftp_schedule_tue_2=>"0", :ftp_schedule_wed_0=>"0", :ftp_schedule_wed_1=>"0", :ftp_schedule_wed_2=>"0", :ftp_schedule_thu_0=>"0", :ftp_schedule_thu_1=>"0", :ftp_schedule_thu_2=>"0", :ftp_schedule_fri_0=>"0", :ftp_schedule_fri_1=>"0", :ftp_schedule_fri_2=>"0", :ftp_schedule_sat_0=>"0", :ftp_schedule_sat_1=>"0", :ftp_schedule_sat_2=>"0",
        :alarm_motion_armed=>"1", :alarm_motion_sensitivity=>"0", :alarm_motion_compensation=>"0", :alarm_input_armed=>"1", :alarm_ioin_level=>"1", :alarm_iolinkage=>"0", :alarm_preset=>"0", :alarm_ioout_level=>"1", :alarm_mail=>"0", :alarm_upload_interval=>"2", :alarm_http=>"0", :alarm_msn=>"0", :alarm_http_url=>"", 
        :alarm_schedule_enable=>"1", :alarm_schedule_sun_0=>"0", :alarm_schedule_sun_1=>"4294967264", :alarm_schedule_sun_2=>"16383", :alarm_schedule_mon_0=>"0", :alarm_schedule_mon_1=>"4294967264", :alarm_schedule_mon_2=>"16383", :alarm_schedule_tue_0=>"0", :alarm_schedule_tue_1=>"4294967264", :alarm_schedule_tue_2=>"16383", :alarm_schedule_wed_0=>"0", :alarm_schedule_wed_1=>"4294967264", :alarm_schedule_wed_2=>"16383", :alarm_schedule_thu_0=>"0", :alarm_schedule_thu_1=>"4294967264", :alarm_schedule_thu_2=>"16383", :alarm_schedule_fri_0=>"0", :alarm_schedule_fri_1=>"4294967264", :alarm_schedule_fri_2=>"16383", :alarm_schedule_sat_0=>"0", :alarm_schedule_sat_1=>"4294967264", :alarm_schedule_sat_2=>"16383",
        :decoder_baud=>"12",
        :msn_user=>"", :msn_pwd=>"", :msn_friend1=>"", :msn_friend2=>"", :msn_friend3=>"", :msn_friend4=>"", :msn_friend5=>"", :msn_friend6=>"", :msn_friend7=>"", :msn_friend8=>"", :msn_friend9=>"", :msn_friend10=>""}
    end

    it "groups the device parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:device)
      results[:device].should have_key(:id)
      results[:device].should have_key(:sys_ver)
      results[:device].should have_key(:app_ver)
      results[:device].should have_key(:alias)
    end
    
    it "groups the clock parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:clock)
      results[:clock].should have_key(:ntp_enable)
      results[:clock].should have_key(:ntp_svr)
      results[:clock].should have_key(:now)
      results[:clock].should have_key(:tz)
      results[:clock].should have_key(:daylight_saving_time)
    end
    
    it "groups the user parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:users)
      results[:users].should be_a_instance_of(Hash)
      results[:users].keys.count.should == ::Foscam::Model::User::MAX_NUMBER
      results[:users].each do |id, user|
        user.should have_key(:name)
        user.should have_key(:pwd)
        user.should have_key(:pri)
      end
    end
    
    it "groups the network parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:network)
      results[:network].should have_key(:ip)
      results[:network].should have_key(:mask)
      results[:network].should have_key(:gateway)
      results[:network].should have_key(:dns)
      results[:network].should have_key(:port)
    end

    it "groups the wifi parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:wifi)
      results[:wifi].should have_key(:enable)
      results[:wifi].should have_key(:ssid)
      results[:wifi].should have_key(:encrypt)
      results[:wifi].should have_key(:defkey)
      results[:wifi].should have_key(:key1)
      results[:wifi].should have_key(:key1_bits)
      results[:wifi].should have_key(:key2)
      results[:wifi].should have_key(:key2_bits)
      results[:wifi].should have_key(:key3)
      results[:wifi].should have_key(:key3_bits)
      results[:wifi].should have_key(:key4)
      results[:wifi].should have_key(:key4_bits)
      results[:wifi].should have_key(:authtype)
      results[:wifi].should have_key(:keyformat)
      results[:wifi].should have_key(:mode)
      results[:wifi].should have_key(:wpa_psk)
    end
    it "groups the pppoe parameters" do    
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:pppoe)
      results[:pppoe].should have_key(:enable)
      results[:pppoe].should have_key(:user)
      results[:pppoe].should have_key(:pwd)
    end
    
    it "groups the upnp parameters" do    
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:upnp)
      results[:upnp].should have_key(:enable)
    end
    
    
    it "groups the ddns parameters" do    
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:ddns)
      results[:ddns].should have_key(:service)
      results[:ddns].should have_key(:user)
      results[:ddns].should have_key(:pwd)
      results[:ddns].should have_key(:host)
      results[:ddns].should have_key(:proxy_svr)
      results[:ddns].should have_key(:proxy_port)
    end
    
    it "groups the mail parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:mail)
      results[:mail].should have_key(:svr)
      results[:mail].should have_key(:port)
      results[:mail].should have_key(:tls)
      results[:mail].should have_key(:user)
      results[:mail].should have_key(:pwd)
      results[:mail].should have_key(:sender)
      results[:mail].should have_key(:receiver1)
      results[:mail].should have_key(:receiver2)
      results[:mail].should have_key(:receiver3)
      results[:mail].should have_key(:receiver4)
      results[:mail].should have_key(:inet_ip)
    end
    
    it "groups the ftp parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:ftp)
      results[:ftp].should have_key(:svr)
      results[:ftp].should have_key(:port)
      results[:ftp].should have_key(:user)
      results[:ftp].should have_key(:pwd)
      results[:ftp].should have_key(:dir)
      results[:ftp].should have_key(:mode)
      results[:ftp].should have_key(:upload_interval)
      results[:ftp].should have_key(:filename)
      results[:ftp].should have_key(:numberoffiles)
      results[:ftp].should have_key(:schedule)
      results[:ftp][:schedule].should have_key(:enable)
      results[:ftp][:schedule].should have_key(:sun_0)
      results[:ftp][:schedule].should have_key(:sun_1)
      results[:ftp][:schedule].should have_key(:sun_2)
      results[:ftp][:schedule].should have_key(:mon_0)
      results[:ftp][:schedule].should have_key(:mon_1)
      results[:ftp][:schedule].should have_key(:mon_2)
      results[:ftp][:schedule].should have_key(:tue_0)
      results[:ftp][:schedule].should have_key(:tue_1)
      results[:ftp][:schedule].should have_key(:tue_2)
      results[:ftp][:schedule].should have_key(:wed_0)
      results[:ftp][:schedule].should have_key(:wed_1)
      results[:ftp][:schedule].should have_key(:wed_2)      
      results[:ftp][:schedule].should have_key(:thu_0)
      results[:ftp][:schedule].should have_key(:thu_1)
      results[:ftp][:schedule].should have_key(:thu_2)      
      results[:ftp][:schedule].should have_key(:fri_0)
      results[:ftp][:schedule].should have_key(:fri_1)
      results[:ftp][:schedule].should have_key(:fri_2)      
      results[:ftp][:schedule].should have_key(:sat_0)
      results[:ftp][:schedule].should have_key(:sat_1)
      results[:ftp][:schedule].should have_key(:sat_2)
    end
    
    
    it "groups the alarm parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:alarm)
      results[:alarm].should have_key(:motion_armed)
      results[:alarm].should have_key(:motion_sensitivity)
      results[:alarm].should have_key(:motion_compensation)
      results[:alarm].should have_key(:input_armed)
      results[:alarm].should have_key(:ioin_level)
      results[:alarm].should have_key(:iolinkage)
      results[:alarm].should have_key(:preset)
      results[:alarm].should have_key(:ioout_level)
      results[:alarm].should have_key(:mail)
      results[:alarm].should have_key(:upload_interval)
      results[:alarm].should have_key(:http)
      results[:alarm].should have_key(:msn)
      results[:alarm].should have_key(:http_url)
      results[:alarm][:schedule].should have_key(:enable)
      results[:alarm][:schedule].should have_key(:sun_0)
      results[:alarm][:schedule].should have_key(:sun_1)
      results[:alarm][:schedule].should have_key(:sun_2)
      results[:alarm][:schedule].should have_key(:mon_0)
      results[:alarm][:schedule].should have_key(:mon_1)
      results[:alarm][:schedule].should have_key(:mon_2)
      results[:alarm][:schedule].should have_key(:tue_0)
      results[:alarm][:schedule].should have_key(:tue_1)
      results[:alarm][:schedule].should have_key(:tue_2)
      results[:alarm][:schedule].should have_key(:wed_0)
      results[:alarm][:schedule].should have_key(:wed_1)
      results[:alarm][:schedule].should have_key(:wed_2)      
      results[:alarm][:schedule].should have_key(:thu_0)
      results[:alarm][:schedule].should have_key(:thu_1)
      results[:alarm][:schedule].should have_key(:thu_2)      
      results[:alarm][:schedule].should have_key(:fri_0)
      results[:alarm][:schedule].should have_key(:fri_1)
      results[:alarm][:schedule].should have_key(:fri_2)      
      results[:alarm][:schedule].should have_key(:sat_0)
      results[:alarm][:schedule].should have_key(:sat_1)
      results[:alarm][:schedule].should have_key(:sat_2)
    end
    
    it "groups the decoder parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:decoder)
      results[:decoder].should have_key(:baud)
    end
  
    it "groups the msn parameters" do
      results = Foscam::Client.send(:group_params, @params)
      results.should have_key(:msn)
      results[:msn].should have_key(:user)
      results[:msn].should have_key(:pwd)
      results[:msn].should have_key(:friend1)
      results[:msn].should have_key(:friend2)
      results[:msn].should have_key(:friend3)
      results[:msn].should have_key(:friend4)
      results[:msn].should have_key(:friend5)
      results[:msn].should have_key(:friend6)
      results[:msn].should have_key(:friend7)
      results[:msn].should have_key(:friend8)
      results[:msn].should have_key(:friend9)
      results[:msn].should have_key(:friend10)
    end    
    
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
        # [:id, :sys_ver, :app_ver, :alias, :now, :tz, :alarm_status, :ddns_status, :ddns_host, :oray_type, :upnp_status, :p2p_status, :p2p_local_port, :msn_status].each do |key|
        #   response.should have_key(key) 
        # end
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
				response.should == nil
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
			it "returns an instance of ::Foscam::Model::Camera" do
				response = @service.get_camera_params
				response.should be_an_instance_of (::Foscam::Model::Camera)
        # [:resolution, :brightness, :contrast, :mode, :flip, :fps].each do |key|
        #   response.should have_key(key) 
        # end
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
				response.should be_nil
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
				[	:device, :clock, :users, :network, :pppoe, :mail, :upnp, :wifi, :alarm, :ftp, :msn].each do |key|
					response.should have_key(key) 
				end
			end
			
			it "device is an instance of Device" do
				response = @service.get_params				
				response[:device].should be_an_instance_of(::Foscam::Model::Device)
			end

			it "clock is an instance of Clock" do
				response = @service.get_params				
				response[:clock].should be_an_instance_of(::Foscam::Model::Clock)
			end
			
			it "returns an array of users" do
				response = @service.get_params				
				response[:users].should be_a_kind_of(Array)
				response[:users].each do |user|
				  user.should be_an_instance_of(::Foscam::Model::User)
			  end
			end
			
			it "network is an instance of Network" do
				response = @service.get_params
        response[:network].should be_an_instance_of(::Foscam::Model::Network)
			end

			it "network is an instance of MailServer" do
				response = @service.get_params
        response[:mail].should be_an_instance_of(::Foscam::Model::MailServer)
			end
			
			it "wifi is an instance of WifiConfig" do
				response = @service.get_params
        response[:wifi].should be_an_instance_of(::Foscam::Model::WifiConfig)
			end

			it "alarm is an instance of AlarmConfig" do
				response = @service.get_params
        response[:alarm].should be_an_instance_of(::Foscam::Model::AlarmConfig)
        response[:alarm].schedule.should be_an_instance_of(::Foscam::Schedule::Week)
			end
			
			it "ftp is an instance of FtpServer" do
				response = @service.get_params
        response[:ftp].should be_an_instance_of(::Foscam::Model::FtpServer)
        response[:ftp].schedule.should be_an_instance_of(::Foscam::Schedule::Week)
			end
			
			it "msn is an instance of Msn" do
				response = @service.get_params
        response[:msn].should be_an_instance_of(::Foscam::Model::Msn)
			end
			
			it "ddns is an instance of Ddns" do
				response = @service.get_params
        response[:ddns].should be_an_instance_of(::Foscam::Model::Ddns)
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

	describe "#upgrade_firmware" do
		around(:each) do |spec|
			::VCR.use_cassette("foscam_upgrade_firmware") do
				spec.run
			end
		end
		it "returns true when successful" do
			@service.upgrade_firmware.should be_true
		end
	end

	describe "#upgrade_htmls" do
		around(:each) do |spec|
			VCR.use_cassette("foscam_upgrade_htmls") do
				spec.run
			end
		end
		it "returns true when successful" do
			@service.upgrade_htmls.should be_true
		end
	end

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
			it "sets the datetime settings" do
				clock = Foscam::Model::Clock.new({:now => 1352782970, :tz =>18000, :ntp_enable => 1, :ntp_svr => "0.ca.pool.ntp.org"})
				response = @service.set_datetime(clock)
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
			it "returns a false" do
				response = @service.set_datetime(Foscam::Model::Clock.new)
				response.should be_false
			end
		end

	end

	describe "#set_users" do
		context "with valid parameters" do
			it "sets user 2 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user2") do
          user = Foscam::Model::User.new({:id => 2, :name => "user2", :pwd => "pass2", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 3 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user3") do
					user = Foscam::Model::User.new({:id => 3, :name => "user3", :pwd => "pass3", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 4 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user4") do
					user = Foscam::Model::User.new({:id => 4, :name => "user4", :pwd => "pass4", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 5 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user5") do
					user = Foscam::Model::User.new({:id => 5, :name => "user5", :pwd => "pass5", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 6 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user6") do
					user = Foscam::Model::User.new({:id => 6, :name => "user6", :pwd => "pass6", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 7 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user7") do
					user = Foscam::Model::User.new({:id => 7, :name => "user7", :pwd => "pass7", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end

			it "sets user 8 name, password, and privilages" do
				::VCR.use_cassette("foscam_set_user8") do
					user = Foscam::Model::User.new({:id => 8, :name => "user8", :pwd => "pass8", :pri => 0})
					response = @service.set_users([user])
					response.should be_true
				end
			end		
		end

		# context "with invalid parameters" do
		# 	it "raises an exception when username or password is more than 12 characters long" do
		# 		[:user1, :pwd1, :user2, :pwd2, :user3, :pwd3, :user4, :pwd4, :user5, :pwd5, :user6, :pwd6, :user7, :pwd7, :user8, :pwd8].each do |key|
		# 			expect {@service.set_users(key => "0123456789123")}.to raise_error
		# 		end
		# 	end
		# end

		context "response is unsuccessful" do
			before(:each) do
				response = ::Faraday::Response.new
				response.stub!(:success?).and_return(false)
				@connection.stub(:get).with('set_users.cgi?').and_return(response)
				@service.connection = @connection
			end
			it "returns a hash of variables" do
				response = @service.set_users([])
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
				network = Foscam::Model::Network.new({:ip => "192.168.0.100", :mask => "0.0.0.0", :gateway => "0.0.0.0", :dns => "8.8.8.8", :port => "8080"})
				response = @service.set_network(network)
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
				response = @service.set_network(Foscam::Model::Network.new)
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
				wifi = Foscam::Model::WifiConfig.new({:ssid => "my_wireless_ssid", :enable => 1, :encrypt => 1, :wpa_psk => "my_wireless_password"})
				response = @service.set_wifi(wifi)
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
					:sun_0 => 95, :sun_1 => 45, :sun_2 => 20,
					:mon_0 => 95, :mon_1 => 45, :mon_2 => 20,
					:tue_0 => 95, :tue_1 => 45, :tue_2 => 20,
					:wed_0 => 95, :wed_1 => 45, :wed_2 => 20,
					:thu_0 => 95, :thu_1 => 45, :thu_2 => 20,
					:fri_0 => 95, :fri_1 => 45, :fri_2 => 20,
					:sat_0 => 95, :sat_1 => 45, :sat_2 => 20
				}
				week = Foscam::Schedule::Week.new(params)
				response = @service.set_forbidden(week)
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
			it "returns an Week" do
				response = @service.get_forbidden
				response.should be_an_instance_of(Foscam::Schedule::Week)
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
				response.should be_nil
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