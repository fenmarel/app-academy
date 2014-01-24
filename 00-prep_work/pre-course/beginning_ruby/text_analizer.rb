class TextAnalysis
  
  def initialize(filename)
    @filename = filename
  end
  
  
  def run_analysis
    @word_count = 0 
    @line_count = 0 
    @char_count = 0
    @char_count_no_white = 0
    @sentence_count = 0
    @paragraph_count = 0
    

    File.open(@filename,:encoding => "ASCII").each_line do |line|
      @line_count += 1
      
      tmp = line.gsub("\n", '')
      @char_count += tmp.length
      
      tmp = tmp.split
      @word_count += tmp.length
      
      tmp = tmp.join
      @char_count_no_white += tmp.length
      
      tmp = tmp.scan(/[!|\.|\?]/)
      @sentence_count += tmp.length
      
      @paragraph_count += 1 if line == "\n"
    end
    
    
    puts "Line Count: \t\t\t #{@line_count}"
    puts "Char Count: \t\t\t #{@char_count}"
    puts "Char Count (No Whitespace): \t #{@char_count_no_white}"
    puts "Word Count: \t\t\t #{@word_count}"
    puts "Paragraph Count: \t\t #{@paragraph_count}"
    puts "Sentence Count: \t\t #{@sentence_count}"
    puts "Avg Sentences/Paragraph: \t #{@sentence_count/@paragraph_count}"
    puts "Avg Words/Sentence: \t\t #{@word_count/@sentence_count}"   
  end
end


oliver = TextAnalysis.new("oliver.txt")
oliver.run_analysis






