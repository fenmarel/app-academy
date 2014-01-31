def deep_dup(original)
  return original unless original.is_a?(Array)

  dup_arr = []
  original.each do |elem|
    dup_arr << deep_dup(elem)
  end

  dup_arr
end


# p deep_dup([1, [2, 3]]) # [1, [2, 3]]
# some_arr = [1, [2, 3, [4, 5]]]
# some_dup = deep_dup(some_arr) # [1, [2, 3, [4, 5]]]
# p some_arr.object_id
# p some_dup.object_id
# p some_arr[1].object_id
# p some_dup[1].object_id