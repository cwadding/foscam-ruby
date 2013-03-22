
module Foscam
	module Schedule
		class ThirdOfADay

			attr_accessor :bit
			
			##
			# @param bit [Fixnum] The 32-bit bitmask representing 8 hours divided into 15 minute blocks
			def initialize(bit)
				self.bit = bit
			end

			##
			# Returns whether the bit is positive or not
			# @param idx [Fixnum] The bit index representing the 15 minute block
			# @return [FalseClass, TrueClass] Whether the bit is equal to 1
			def active?(idx)
				binary_string[31-idx].to_i > 0
			end

			##
			# Convert the bitmask representing a third of a day with a Hash. The key is the idx of the bit and the value is a boolean of whether it is active or not
			# @return [Hash]
			def to_hash
				h = {}
				i = 0
				binary_string.reverse.each_char do |char|
					h.merge!({i => char.to_i > 0})
					i = i + 1
				end
				h
			end

			private

			def binary_string
				@str ||= ("%032d" % self.bit.to_s(2))
			end
		end
	end
end