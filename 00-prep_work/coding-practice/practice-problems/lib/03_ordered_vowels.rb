def ordered_vowel_words(str)
  words = str.split
  words.select { |word| v_order(word) }.join(' ')
end

def v_order(word)
  vowels = word.split('').select { |c| !!(c =~ /a|e|i|o|u/) }
  vowels.sort == vowels
end
