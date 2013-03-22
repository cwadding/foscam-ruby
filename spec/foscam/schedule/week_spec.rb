require 'spec_helper'

describe Foscam::Schedule::Week do

	def valid_params
		{
			:sun_0 => 1,		# 00:00 - 00:15
			:sun_1 => 2,		# 08:15 - 08:30
			:sun_2 => 4,		# 16:30 - 16:45
			:mon_0 => 8,		# 00:45 - 01:00
			:mon_1 => 16,		# 09:00 - 09:15
			:mon_2 => 32,		# 17:15 - 17:30
			:tue_0 => 64,		# 01:30 - 01:45
			:tue_1 => 128,		# 09:45 - 10:00
			:tue_2 => 256,		# 18:00 - 18:15
			:wed_0 => 512,		# 02:15 - 02:30
			:wed_1 => 1024,		# 10:30 - 10:45
			:wed_2 => 2048,		# 18:45 - 19:00
			:thu_0 => 4096,		# 03:00 - 03:15
			:thu_1 => 8192,		# 11:15 - 11:30
			:thu_2 => 16384,	# 19:30 - 19:45
			:fri_0 => 32768,	# 03:45 - 04:00
			:fri_1 => 65536,	# 12:00 - 12:15
			:fri_2 => 131072,	# 20:15 - 20:30
			:sat_0 => 262144,	# 04:30 - 04:45
			:sat_1 => 524288,	# 12:45 - 13:00
			:sat_2 => 1048576,	# 21:00 - 21:15
		}
	end

	describe "#to_hash" do
		before(:each) do
			@week = Foscam::Schedule::Week.new(valid_params)
		end
		it "returns a hash with 7 keys" do
			h = @week.to_hash
			h.should be_a_kind_of(Hash)
			h.keys.length.should == 7
		end
		it "uses the days of the week as the keys" do
			h = @week.to_hash
			[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
				h.should have_key(day)
			end
		end
		it "converts each of the days as a value to a hash" do
			# @week.days.each do |day|
			# 	day.should_receive(:to_hash).once
			# end
			h = @week.to_hash
			[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
				h[day].should be_a_kind_of(Hash)
				h[day].keys.length.should == 96
			end
		end
	end

	describe "#busy_at?" do
		context "with even bits set" do
			before(:each) do
				@week = Foscam::Schedule::Week.new(valid_params)
			end
			it "is busy in the first 15 minutes of each eight hour block" do
				# sunday
				@week.should be_busy_at(Time.new(2013,5,5,0,5,0))	# 00:00 - 00:15
				@week.should be_busy_at(Time.new(2013,5,5,8,20,0))	# 08:15 - 08:30
				@week.should be_busy_at(Time.new(2013,5,5,16,35,0))	# 16:30 - 16:45

				# # monday
				@week.should be_busy_at(Time.new(2013,5,6,0,50,0))	# 00:45 - 01:00
				@week.should be_busy_at(Time.new(2013,5,6,9,5,0))	# 09:00 - 09:15
				@week.should be_busy_at(Time.new(2013,5,6,17,20,0))	# 17:15 - 17:30


				# tuesday
				@week.should be_busy_at(Time.new(2013,5,7,1,35,0))	# 01:30 - 01:45
				@week.should be_busy_at(Time.new(2013,5,7,9,50,0))	# 09:45 - 10:00
				@week.should be_busy_at(Time.new(2013,5,7,18,5,0))	# 18:00 - 18:15

				# wednesday
				@week.should be_busy_at(Time.new(2013,5,8,2,20,0))	# 02:15 - 02:30
				@week.should be_busy_at(Time.new(2013,5,8,10,35,0))	# 10:30 - 10:45
				@week.should be_busy_at(Time.new(2013,5,8,18,50,0))	# 18:45 - 19:00

				# thursday
				@week.should be_busy_at(Time.new(2013,5,9,3,5,0))	# 03:00 - 03:15
				@week.should be_busy_at(Time.new(2013,5,9,11,20,0))	# 11:15 - 11:30
				@week.should be_busy_at(Time.new(2013,5,9,19,35,0))	# 19:30 - 19:45

				# friday
				@week.should be_busy_at(Time.new(2013,5,10,3,50,0)) # 03:45 - 04:00
				@week.should be_busy_at(Time.new(2013,5,10,12,05,0))# 12:00 - 12:15
				@week.should be_busy_at(Time.new(2013,5,10,20,20,0))# 20:15 - 20:30

				# saturday
				@week.should be_busy_at(Time.new(2013,5,11,4,35,0))	# 04:30 - 04:45
				@week.should be_busy_at(Time.new(2013,5,11,12,50,0))# 12:45 - 13:00
				@week.should be_busy_at(Time.new(2013,5,11,21,5,0))	# 21:00 - 21:15
			end
		end
	end
end