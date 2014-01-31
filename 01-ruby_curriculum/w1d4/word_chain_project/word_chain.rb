
class WordChainFinder
  def initialize(dictionary='dictionary.txt')
    @full_dictionary = File.read(dictionary).split("\n")
  end

  def solve_word_chain(word, target)
    reset_parameters(word, target)
    build_path
  end


  private

  def reset_parameters(word, target)
    @word = word
    @target = target
    @words_to_expand = [word]
    @all_reachable_words = [word]
    @parents = Hash.new
    @candidate_words = same_length_words
  end

  def find_chain(source, target)
    @words_to_expand = [source]
    @candidate_words = same_length_words
    current_word = nil

    until @words_to_expand.empty? || current_word == target
      current_word = @words_to_expand.shift
      adjacents = adjacent_words(current_word, @candidate_words)
      adjacents.each { |word| @parents[word] ||= current_word }

      @words_to_expand += adjacents - @words_to_expand
      @candidate_words.delete(current_word)
    end

    @parents
  end

  def build_path
    current_word = @target
    find_chain(@word, @target)
    path = []

    until current_word == @word
      path << current_word
      current_word = @parents[current_word]
    end

    path << current_word
    path.reverse
  end

  def same_length_words
    @full_dictionary.select { |w| w.length == @word.length }
  end

  def adjacent_words(word, dictionary)
    dictionary.select { |w| close_match?(word, w) }
  end

  def close_match?(word, candidate)
    counter = 0
    (0...word.length).each do |idx|
      counter += 1 if word[idx] == candidate[idx]
    end

    counter == word.length - 1
  end
end

w = WordChainFinder.new
p w.solve_word_chain("duck", "ruby")
