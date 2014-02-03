require 'set'

class WordChains
  def initialize(dictionary)
    @dictionary = File.read(dictionary).split("\n")
    @candidate_words = nil
    @words_to_expand = nil
    @parents = Hash.new
    @source_word = nil
    @target_word = nil
  end

  def find_chain(source, target)
    @source_word = source
    @target_word = target

    explore_words(source)
    find_source_path
  end


  private

  def explore_words(source)
    @candidate_words = Set.new(@dictionary.select { |word| word.length == source.length })
    @words_to_expand = [source]
    @parents = Hash.new

    until @words_to_expand.empty?
      next_word = @words_to_expand.shift
      next_words = adjacent_words(next_word)

      next_words.each do |word|
        @words_to_expand << word unless @parents.include?(word)
        @parents[word] ||= next_word
      end
    end

    self
  end

  def adjacent_words(word)
    words = []
    word.split('').each_with_index do |char, i|
      ('a'..'z').each do |letter|
        new_word = word.dup
        unless word[i] == letter
          new_word[i] = letter
          words << new_word if @candidate_words.include?(new_word)
        end
      end
    end

    words
  end

  def find_source_path
    path = [@target_word]

    until path.first == @source_word
      current = path.first
      raise RuntimeError.new("impossible chain") if @parents[current].nil?
      path.unshift(@parents[current])
    end

    path
  end
end


# w = WordChains.new('dictionary.txt')
# p w.find_chain('cat', 'dog')
# p w.find_chain('grape', 'brine')
# p w.find_chain('crime', 'brie') # raises error