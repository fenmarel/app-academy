class Array
	def my_each
		temp_arr = self.dup
		until temp_arr.empty? do
			yield temp_arr.shift
		end
		return self
	end

	def median
		sorted = self.sort
		len = self.length
		mid = len / 2

		if len.odd?
			sorted[mid]
		else
			(sorted[mid] + sorted[mid - 1]) / 2.0
		end
	end
end



def each_multiplied_by_two(arr)
		# multiplies each contents of the enumerable by 2
		arr.map { |element| element * 2 }
end

def concatenate(arr)
	arr.inject(:+)
end



# p each_multiplied_by_two([1, 2, 3, 4, 5])

# return_value = [1, 2, 3].my_each do |num|
#   puts num
# end.my_each do |num|
#   puts num
# end

# p [1, 2, 3, 4, 5].median
# p [1, 6, 3, 4, 2, 5].median

p concatenate(["Yay ", "for ", "strings!"])