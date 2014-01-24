def nearest_larger(arr, idx)
  check = arr[idx]
  len = arr.length
  return nil if arr.max == check
  
  diff = 1
  loop do  
    left_dex = idx - diff
    right_dex = idx + diff
    
    if left_dex >= 0 && arr[left_dex] > check
      return left_dex
    elsif right_dex < len && arr[right_dex] > check
      return right_dex
    end
    
    diff += 1
  end
end 
