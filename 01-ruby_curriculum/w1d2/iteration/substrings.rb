def substrings(str)
  [].tap do |strings|
    length = str.length
    (0...length).each do |i|
      (i...length).each do |j|
        strings << str[i..j]
      end
    end
  end
end

def subwords(str, dict)
  words = substrings(str)
  words.select { |word| dict.include?(word) }
end


# # create a local dictionary for testing
# dictionary = []
# File.open('dictionary.txt').each_line do |line|
#   dictionary << line.chomp
# end
# 
# p substrings("cat")
# p subwords("cat", dictionary)
