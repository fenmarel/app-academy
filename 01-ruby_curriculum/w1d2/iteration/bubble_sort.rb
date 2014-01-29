def bubble_sort(arr)
  sorted_array = arr.dup
  end_index = sorted_array.length
  sorted = false

  until sorted do
    sorted = true

    (0...end_index - 1).each do |i|
      current_val = sorted_array[i] 
      next_val = sorted_array[i + 1]
      
      if current_val > next_val
        sorted_array[i], sorted_array[i + 1] = next_val, current_val
        sorted = false
      end
    end
  end
  sorted_array
end

# p bubble_sort([1, 3, 65, 23, 5, 3, 2, 6, 7, 7,4, 0])