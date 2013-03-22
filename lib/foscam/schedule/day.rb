module Foscam
	module Schedule
		class Day

			##
			# @param bit1 [Fixnum] The 32-bit bitmask representing the first third of the day
			# @param bit2 [Fixnum] The 32-bit bitmask representing the second third of the day
			# @param bit3 [Fixnum] The 32-bit bitmask representing the last third of the day
			def initialize(bit1, bit2, bit3)
				self.bits = Array.new(3)
				self.bits[0] = ThirdOfADay.new(bit1)
				self.bits[1] = ThirdOfADay.new(bit2)
				self.bits[2] = ThirdOfADay.new(bit3)
			end
			
			attr_accessor :bits

			##
			# Determine if the the schedule is true at the given date time
			# @param time [Time, Fixnum, DateTime] Accepts multiple forms of time. If a Datetime or Time is used then only the time of day is used. If a fixnum is given then it is a number representing the number of seconds from the start of the day.
			# @return [FalseClass, TrueClass] Whether it is busy at that time
			def busy_at?(time)
				case time
				when Fixnum
					bit = seconds/28800
					bit_num = bit_from_time(seconds/3600, seconds % 3600)
				when DateTime
					time = time.to_time
					bit = time.hour / 8
					bit_num = bit_from_time(time.hour, time.min)
				when Time
					bit = time.hour / 8
					bit_num = bit_from_time(time.hour, time.min)
				else

				end
				self.bits[bit].active?(bit_num)
			end

			##
			# Convert the Week to a nested hash with the day of the week as the key and and time as the second key
			# @return [Hash]
			def to_hash
				h = {}
				self.bits.each_index do |idx|
					bits[idx].to_hash.each do |j, value|
						minute = (j % 4) * 15
						hour = j / 4 + idx * 8
						h.merge!("#{"%02d" % hour}:#{"%02d" % minute}" => value)
					end
				end
				h
			end

			# takes three integers
			private

			def bit_from_time(hours, minutes)
				(hours % 8)*4 + minutes/15
			end
		end
	end
end