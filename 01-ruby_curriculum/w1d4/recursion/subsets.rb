def subsets(array)
  return [[]] if array.empty?

  new_subsets = subsets(array.drop(1))
  new_subsets += new_subsets.map {|subset| subset + array.take(1)}
  new_subsets.sort
end


# p subsets([]) # => [[]]
# p subsets([1]) # => [[], [1]]#
# p subsets([1, 2]) # => [[], [1], [2], [1, 2]]
# p subsets([1, 2, 3, 4, 5]).count # 32
