def word_unscrambler(str, words)
  check = str.split('').sort.join
  words.select { |word| word.split('').sort.join == check }
end
