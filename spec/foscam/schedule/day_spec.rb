require 'spec_helper'

describe Foscam::Schedule::Day do

	before(:each) do
		@day = Foscam::Schedule::Day.new(0,0,0)
	end
	describe "#to_hash" do
		it "returns a hash with 96 keys" do
			h = @day.to_hash
			h.should be_a_kind_of(Hash)
			h.keys.length.should == 96
		end
		it "uses the times as the keys" do
			h = @day.to_hash
			23.times do |hour|
				[0,15,30,45].each do |minute|
					h.should have_key("#{"%02d" % hour}:#{"%02d" % minute}")
				end
			end
		end
	end

	describe "#busy_at?" do
		context "with even bits set" do
			before(:each) do
				@day = Foscam::Schedule::Day.new(1,1,1)
			end
			it "is busy in the first 15 minutes of each eight hour block" do
				@day.should be_busy_at(Time.new(2013,5,2,0,5,0))
				@day.should be_busy_at(Time.new(2013,5,2,8,5,0))
				@day.should be_busy_at(Time.new(2013,5,2,16,5,0))
				@day.should_not be_busy_at(Time.new(2013,5,2,17,5,0))
			end
		end
	end
end