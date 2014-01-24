def letter_count(str)
  ans = Hash.new(0)
  str.gsub(' ', '').split('').map { |c| ans[c] += 1 }
  ans
end
