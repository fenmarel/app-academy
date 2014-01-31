def merge_sort(array)
  return array if array.length <= 1

  mid_idx = array.length / 2
  left = array[0...mid_idx]
  right = array[mid_idx..-1]

  merge(merge_sort(left), merge_sort(right))
end

def merge(left, right)
  sorted_arr = []
  until left.empty? || right.empty?
    if left.first < right.first
      sorted_arr << left.shift
    else
      sorted_arr << right.shift
    end
  end

  left.empty? ? sorted_arr += right : sorted_arr += left
end

# p merge_sort([])
# p merge_sort([6])
# p merge_sort([6, 5, 4, 3, 3, 2])
# p merge_sort([1, 2, 3, 4, 5])