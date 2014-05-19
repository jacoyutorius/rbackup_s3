module AWS
	class S3
		class ObjectCollection
			def find key
				self.each do |v|
					return true if v.key == key
				end

				return false
			end

			def filter_by_key key
				filterd = []
				self.each do |v|
					filterd << v if v.key == key
				end

				filterd
			end

		end
	end
end
