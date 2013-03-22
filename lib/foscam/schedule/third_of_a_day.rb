require 'debugger'
module Foscam
	module Schedule
		class ThirdOfADay

			attr_accessor :bit
			
			def initialize(bit)
				self.bit = bit
			end

			def active?(idx)
				# debugger
				binary_string[31-idx].to_i > 0
			end

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