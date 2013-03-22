module Foscam
	module Schedule
		class Week
			# attr_accessor :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday
			attr_accessor :days

			def initialize(params = {})
				self.days = {}
				[:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
					abbrev = day.to_s[0..2]
					self.days.merge!( day => Day.new(params["#{abbrev}_0".to_sym], params["#{abbrev}_1".to_sym], params["#{abbrev}_2".to_sym]))
				end
			end


			def busy_at?(time)
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

			def to_hash
				h = {}
				self.days.each do |name, day|
					h.merge!(name => day.to_hash)
				end
				h
			end
		end
	end
end