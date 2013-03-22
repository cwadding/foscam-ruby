require 'spec_helper'

describe Foscam::Schedule::ThirdOfADay do

	before(:each) do
		@toad = Foscam::Schedule::ThirdOfADay.new(1431655765)
	end
	describe "#to_hash" do
		it "returns a hash with 32 values" do
			h = @toad.to_hash
			h.should be_a_kind_of(Hash)
			h.keys.length.should == 32
		end
		it "sets the busy times to true and otherwise false" do
			h = @toad.to_hash
			32.times do |i|
				if (i % 2 == 0)
					h[i].should be_true
				else
					h[i].should be_false
				end
				
			end
		end
	end

	describe "#active?" do
		context "with even bits set" do
			before(:each) do
				@toad = Foscam::Schedule::ThirdOfADay.new(286331153)
			end
			it "is busy in the first 15 minutes of each hour" do
				[0,4,8,12,16,20,24,28].each do |idx|
					@toad.should be_active(idx)
				end
				[1,2,3,5,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,27,29,30,31].each do |idx|
					@toad.should_not be_active(idx)
				end
			end
		end
	end
end