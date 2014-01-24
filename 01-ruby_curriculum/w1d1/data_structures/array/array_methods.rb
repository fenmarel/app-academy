class Array
	def my_uniq
		# returns the unique elements in the order in which they first appeared
		unique_contents = []
		self.each do |element|
			if not unique_contents.include? element
				unique_contents << element
			end
		end
		unique_contents
	end

	def two_sum
		# finds all pairs of positions where the elements at those positions sum to zero.
		results = []
		end_dex = self.length - 1
		self.each_with_index do |start, first_num_dex|
			((first_num_dex + 1)..end_dex).each do |second_num_dex|
				if start == (0 - self[second_num_dex])
					results << [first_num_dex, second_num_dex]
				end
			end
		end
		results
	end

	def my_transpose
		# convert between the row-oriented and column-oriented representations of a matrix
		transposed = []
		self.first.length.times { transposed << [] }
		
		self.each_with_index do |sub_arr, dex|
			len = sub_arr.length
			sub_arr.each_with_index do |num, position|
				transposed[position][dex] = num
			end
		end
		transposed
	end
end

# p [1, 2, 1, 3, 3].my_uniq
# p [-1, 0, 2, -2, 1].two_sum
# p [[0, 1], [2, 3], [4, 5]].my_transpose

