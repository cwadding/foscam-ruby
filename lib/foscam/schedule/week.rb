module Foscam
	module Schedule
		class Week
			# attr_accessor :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday
			attr_accessor :days

			##
			# @param [Hash] params Each input is a 32-bit bitmask representing a an 8 hour period divided into 15 minute block. Three inputs are needed for each day to to represent a full 24 hour of 96-bits.
			# @option params [Fixnum] :fri_0
			# @option params [Fixnum] :fri_1
			# @option params [Fixnum] :fri_2
			# @option params [Fixnum] :mon_0
			# @option params [Fixnum] :mon_1
			# @option params [Fixnum] :mon_2
			# @option params [Fixnum] :sat_0
			# @option params [Fixnum] :sat_1
			# @option params [Fixnum] :sat_2
			# @option params [Fixnum] :sun_0
			# @option params [Fixnum] :sun_1
			# @option params [Fixnum] :sun_2
			# @option params [Fixnum] :thu_0
			# @option params [Fixnum] :thu_1
			# @option params [Fixnum] :thu_2
			# @option params [Fixnum] :tue_0
			# @option params [Fixnum] :tue_1
			# @option params [Fixnum] :tue_2
			# @option params [Fixnum] :wed_0
			# @option params [Fixnum] :wed_1
			# @option params [Fixnum] :wed_2
			def initialize(params = {})
				self.days = {}
				[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
					abbrev = day.to_s[0..2]
					bit0 = params.has_key?("#{abbrev}_0".to_sym) ? params["#{abbrev}_0".to_sym] : 0
					bit1 = params.has_key?("#{abbrev}_1".to_sym) ? params["#{abbrev}_1".to_sym] : 0
					bit2 = params.has_key?("#{abbrev}_2".to_sym) ? params["#{abbrev}_2".to_sym] : 0
					self.days.merge!( day => Day.new(bit0,bit1,bit2))
				end
			end

			##
			# Determine if the the schedule is true at the given date time
			# @param time [Time, DateTime]
			# @return [FalseClass, TrueClass] Whether the schedule is true at that time
			def busy_at?(time)
				time = time.to_time if time.is_a?(DateTime)
				if time.sunday?
					days[:sunday].busy_at?(time)
				elsif time.monday?
					days[:monday].busy_at?(time)
				elsif time.tuesday?
					days[:tuesday].busy_at?(time)
				elsif time.wednesday?
					days[:wednesday].busy_at?(time)
				elsif time.thursday?
					days[:thursday].busy_at?(time)
				elsif time.friday?
					days[:friday].busy_at?(time)
				elsif time.saturday?
					days[:saturday].busy_at?(time)
				end
			end
			
			##
			# Convert the Week to a nested hash with the day of the week as the key and and time as the second key
			# @return [Hash]
			def to_hash
				h = {}
				self.days.each do |name, day|
					h.merge!(name => day.to_hash)
				end
				h
			end
			##
			# Convert the Week to the form of the input hash
			# @return [Hash]
			def to_param
				params = {}
				self.days.each do |name, day|
					abbrev = name.to_s[0..2]
					day.bits.each_index do |i|
						params.merge!("#{abbrev}_#{i}".to_sym => day.bits[i].bit)
					end
				end
				params
			end
		end
	end
end