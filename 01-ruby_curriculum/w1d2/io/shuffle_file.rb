def shuffle_file_lines(filename)
  contents = File.read(filename).split("\n")
  
  File.open('shuffled.txt', 'w') do |f|
    contents.shuffle.each { |line| f.puts line }
  end
end

# shuffle_file_lines('lines_of_words.txt')