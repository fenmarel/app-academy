def bubble_sort(arr)
  swap = true
  until swap == false do
    swap = false
    (0...arr.length - 1).each do |dex|
      if arr[dex] > arr[dex+1]
        arr[dex], arr[dex+1] = arr[dex+1], arr[dex]
        swap = true
      end
    end
  end
  arr
end
