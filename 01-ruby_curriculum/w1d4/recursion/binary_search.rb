def bsearch(array, target)
  # input array must be sorted
  return nil if array.empty?

  guess_index = array.length / 2
  guess = array[guess_index]

  if target == guess
    return guess_index
  elsif target < guess
    bsearch(array[0...guess_index], target)
  else
    guess_index + bsearch(array[(guess_index)..-1], target)
  end
end


# p bsearch([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 8)
# p bsearch([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 4)
# p bsearch([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 6)
# p bsearch([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2)
# p bsearch([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10)
