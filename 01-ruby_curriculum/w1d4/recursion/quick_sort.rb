def quick_sort(array)
  return array if array.length <= 1
  pivot = array.length / 2
  left = array.select {|num| num < array[pivot]}
  right = array.select {|num| num > array[pivot]}

  quick_sort(left) + [array[pivot]] + quick_sort(right)
end

p quick_sort([6, 5, 4, 3, 2, 1])
p quick_sort([])
p quick_sort([6])
p quick_sort([1, 2, 3, 4, 5])
p quick_sort([-1, 4, 2, 78, 3, -53, 6])


# recommended by Buck