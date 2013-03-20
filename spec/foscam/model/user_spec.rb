require 'spec_helper'

describe Foscam::Model::User do

	def all_users_response
		{
			:user1_name => "user_1", :user1_pwd => "pass_1", :user1_pri => :administrator,
			:user2_name => "user_2", :user2_pwd => "pass_2", :user2_pri => :administrator,
			:user3_name => "user_3", :user3_pwd => "pass_3", :user3_pri => :administrator,
			:user4_name => "user_4", :user4_pwd => "pass_4", :user4_pri => :administrator,
			:user5_name => "user_5", :user5_pwd => "pass_5", :user5_pri => :administrator,
			:user6_name => "user_6", :user6_pwd => "pass_6", :user6_pri => :administrator,
			:user7_name => "user_7", :user7_pwd => "pass_7", :user7_pri => :administrator,
			:user8_name => "user_8", :user8_pwd => "pass_8", :user8_pri => :administrator,
		}
	end

	def one_user_response
		{
			:user1_name => "user_1", :user1_pwd => "pass_1", :user1_pri => :administrator,
			:user2_name => "", :user2_pwd => "", :user2_pri => :visitor,
			:user3_name => "", :user3_pwd => "", :user3_pri => :visitor,
			:user4_name => "", :user4_pwd => "", :user4_pri => :visitor,
			:user5_name => "", :user5_pwd => "", :user5_pri => :visitor,
			:user6_name => "", :user6_pwd => "", :user6_pri => :visitor,
			:user7_name => "", :user7_pwd => "", :user7_pri => :visitor,
			:user8_name => "", :user8_pwd => "", :user8_pri => :visitor,
		}
	end

	def valid_params
		{:username => 'foobar', :password => 'secret', :privilege => :administrator}
	end
	before(:all) do
		@client = ::Foscam::Client.new({:url => "http://192.168.0.1/", :username => "foobar", :password => "secret"})
	end
	describe ".all" do
		it "returns an array of all the users" do
			@client.stub(:get_params).and_return(all_users_response)
			@client.should_receive(:get_params).once
			Foscam::Model::User.connection = @client
			users = Foscam::Model::User.all
			users.count.should == 8
			index = 1
			users.each do |user|
				user.should be_an_instance_of(Foscam::Model::User)
				user.id.should == index
				user.username.should == "user_#{index}"
				user.password.should == "pass_#{index}"
				user.privilege.should == :administrator
				index += 1
			end
		end
	end

	describe ".create" do
		it "builds a user and then saves it" do
			Foscam::Model::User.any_instance.stub(:save).and_return(true)
			Foscam::Model::User.any_instance.should_receive(:save).once
			user = Foscam::Model::User.create(valid_params)
			user.should_not be_nil
			user.username.should == valid_params[:username]
			user.password.should == valid_params[:password]
			user.privilege.should == valid_params[:privilege]
		end
	end

	describe ".find" do
		before(:each) do
			@client.stub(:get_params).and_return(one_user_response)
		end
		context "when user exists" do
			context "with valid id" do
				it "returns the desired user by id" do
					@client.should_receive(:get_params).once
					Foscam::Model::User.connection = @client
					user = Foscam::Model::User.find(1)
					user.should be_an_instance_of(Foscam::Model::User)
					user.id.should == 1
					user.username.should == "user_1"
					user.password.should == "pass_1"
					user.privilege.should == :administrator
				end
			end
		end

		context "when user doesn't exists" do
			context "with valid id" do
				it "returns a nil object" do
					@client.should_receive(:get_params).once
					Foscam::Model::User.connection = @client
					user = Foscam::Model::User.find(2)
					user.should be_nil
				end
			end
			context "with invalid id" do
				it "returns a nil object" do
					@client.should_not_receive(:get_params)
					Foscam::Model::User.connection = @client
					user = Foscam::Model::User.find(10)
					user.should be_nil
				end
			end
		end		
	end

	describe ".delete" do
		context "with valid id" do
			it "deletes the desired user" do
				params = {:user1 => "", :pwd1 => "", :pri1 => 0}
				@client.stub(:set_users).with(params).and_return(true)
				@client.should_receive(:set_users).with(params).once
				Foscam::Model::User.connection = @client
				flag = Foscam::Model::User.delete(1)
				flag.should be_true
			end
		end
		context "with invalid id" do
			it "deletes the desired user" do
				@client.should_not_receive(:set_users)
				Foscam::Model::User.connection = @client
				flag = Foscam::Model::User.delete(10)
				flag.should be_false
			end
		end
	end

	describe "#save" do
		context "a new user" do
			before(:each) do
				@user = Foscam::Model::User.new(valid_params)
			end

			context "with valid params" do
				before(:each) do 
					@user.stub(:is_valid?).and_return(true)
				end

				context "with less than the maximum number of users" do
					before(:each) do 
						@client.stub(:get_params).and_return(one_user_response)
						params = {:user2 => @user.username, :pwd2 => @user.password, :pri2 => :administrator}
						@client.should_receive(:set_users).with(params).once
					end
					context "request is successful" do
						before(:each) do
							@client.stub(:set_users).and_return(true)
						end
						it "updates the user attributes that changed" do
							Foscam::Model::User.connection = @client						
							flag = @user.save
							flag.should be_true
						end
					end
					context "request is unsuccessful" do
						before(:each) do
							@client.stub(:set_users).and_return(false)
						end
						it "fails to update the user attributes" do							
							Foscam::Model::User.connection = @client
							flag = @user.save
							flag.should be_false
						end
					end
				end
				context "with the maximum number of users" do
					before(:each) do
						@client.stub(:get_params).and_return(all_users_response)
					end
					it "skips creation since no spots are available for new users" do
						@client.should_not_receive(:set_users)
						Foscam::Model::User.connection = @client
						flag = @user.save
						flag.should be_false
					end
				end
			end
			context "with invalid params" do
				before(:each) do
					@user.stub(:is_valid?).and_return(false)
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_users)
					Foscam::Model::User.connection = @client
					flag = @user.save
					flag.should be_false
				end
			end
		end	

		context "an existing user" do
			before(:each) do
				@client.stub(:get_params).and_return(one_user_response)
				@user = Foscam::Model::User.find(1)
			end
			context "with valid params" do
				before(:each) do 
					@user.username = "foobar"
					@user.password = "secret"
					@user.stub(:is_valid?).and_return(true)
				end
				context "is dirty" do
					before(:each) do 
						@user.stub(:changed?).and_return(true)
						params = {:user1 => @user.username, :pwd1 => @user.password, :pri1 => :administrator}
						@client.should_receive(:set_users).with(params).once
					end
					context "request is successful" do
						before(:each) do
							@client.stub(:set_users).and_return(true)
						end
						it "updates the user attributes that changed" do
							Foscam::Model::User.connection = @client					
							flag = @user.save
							flag.should be_true
						end
					end
					context "request is unsuccessful" do
						before(:each) do
							@client.stub(:set_users).and_return(false)
						end
						it "fails to update the user attributes" do
							Foscam::Model::User.connection = @client
							flag = @user.save
							flag.should be_false
						end
					end
				end
				context "is not dirty" do
					before(:each) do
						@user.stub(:changed?).and_return(false)						
					end
					it "skips updating since nothing changed" do
						@client.should_not_receive(:set_users)
						Foscam::Model::User.connection = @client
						flag = @user.save
						flag.should be_false
					end
				end
			end
			context "with invalid params" do
				before(:each) do
					@user.stub(:is_valid?).and_return(false)
				end
				it "skips updating since nothing changed" do
					@client.should_not_receive(:set_users)
					Foscam::Model::User.connection = @client
					flag = @user.save
					flag.should be_false
				end
			end
		end	
	end

	describe "#==" do
		before(:each) do
			@user = Foscam::Model::User.new(valid_params)
		end
		it "returns true if the other is the same object" do
			flag = @user == @user
			flag.should be_true
		end

		it "returns false if it is not an instance of Foscam::Model::User" do
			flag = @user == valid_params
			flag.should be_false
		end

		it "returns false if it is an instance of Foscam::Model::User but the ids are different" do
			user2 = Foscam::Model::User.new(valid_params)
			@user.instance_variable_set(:@id, 1)
			user2.instance_variable_set(:@id, 2)
			flag = @user == user2
			flag.should be_false
		end

		it "returns false if either or both ids is not set" do
			user2 = Foscam::Model::User.new({:username => "user_1", :password => "pass_1", :privilege => :administrator})
			flag = @user == user2
			flag.should be_false
			@user.instance_variable_set(:@id, 1)
			flag = @user == user2
			flag.should be_false
			@user.instance_variable_set(:@id, nil)
			user2.instance_variable_set(:@id, 1)
			flag = @user == user2
			flag.should be_false
		end
	end

	describe "#destroy" do
		context "on a new user" do
			before(:each) do
				@user = Foscam::Model::User.new(valid_params)
			end
			it "should set the user attributes to be blank" do
				@client.should_not_receive(:set_users)
				Foscam::Model::User.connection = @client
				flag = @user.destroy
				flag.should be_false
				@user.username.should == ""
				@user.password.should == ""
				@user.privilege.should == 0
			end
		end
		context "an existing user" do
			before(:each) do
				@client.stub(:get_params).and_return(one_user_response)
				@user = Foscam::Model::User.find(1)
			end			
			it "should save the user with blank usernames, password and privileges" do
				params = {:user1 => "", :pwd1 => "", :pri1 => 0}
				@client.stub(:set_users).with(params).and_return(true)
				@client.should_receive(:set_users).with(params).once
				Foscam::Model::User.connection = @client
				flag = @user.destroy
				flag.should be_true
			end
		end
	end

end