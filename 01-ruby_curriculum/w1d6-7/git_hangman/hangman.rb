class Hangman
  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player
    @checking_player = checking_player
    @secret_word = nil
    @gamestate = nil
    @turns_left = 10
  end

  def play
    puts "*" * 22
    puts "* WELCOME TO HANGMAN *"
    puts "*" * 22

    @secret_word = @checking_player.pick_secret_word
    @guessing_player.get_secret_length(@secret_word.length)
    @turns_left = 10

    update_gamestate
    @guessing_player.get_gamestate(@gamestate)

    until won? || @turns_left == 0
      display_gamestate

      take_turn
    end

    display_gamestate
    if won?
      puts "You win! The word was #{@secret_word}!"
      puts "You had #{@turns_left} turns to spare!"
    else
      puts "You ran out of turns, you lose! The word was #{@secret_word}!"
    end

    self
  end


  private

  def take_turn
    puts "You have #{@turns_left} turns left."
    current_guess = @guessing_player.guess
    correct_indices = @checking_player.check_guess(current_guess)
    guess_success = !correct_indices.empty?
    @turns_left -= 1 unless guess_success

    @guessing_player.get_guess_success(guess_success, current_guess)
    update_gamestate(correct_indices)
    @guessing_player.get_gamestate(@gamestate)
  end

  def update_gamestate(indices=[])
    @gamestate ||= Array.new(@secret_word.length) { nil }

    indices.each do |i|
      @gamestate[i] = @secret_word[i]
    end

    self
  end

  def display_gamestate
    @gamestate.each do |letter|
      letter.nil? ? print("_  ") : print("#{letter}  ")
    end
    puts
    @gamestate.each_index do |i|
      i > 9 ? print("#{i} ") : print("#{i}  ")
    end
    puts "\n\n"

    self
  end

  def won?
    @gamestate.join == @secret_word
  end

end


class Player
  def initialize(dictionary)
    @dictionary = File.read(dictionary).gsub(/[-']/, '').split("\n")
    @secret_word = nil
    @secret_length = nil
    @available_letters = ('a'..'z').to_a
    @current_gamestate = nil
    @guess_success = false
  end

  def get_secret_length(len)
    @secret_length = len
    self
  end

  def get_gamestate(gamestate)
    @current_gamestate = gamestate
    self
  end

  def get_guess_success(success, guess)
    @guess_success = success
    self
  end
end


class HumanPlayer < Player
  def initialize(dictionary)
    super(dictionary)
  end

  def pick_secret_word
    puts "Please choose a secret word:"

    @secret_word = gets.chomp
    until @dictionary.include?(@secret_word)
      puts "Word must be in the available vocabulary. Try again:"
      @secret_word = gets.chomp
    end

    @secret_word
  end

  def guess
    puts "Please select a letter."
    puts "Available letters: #{@available_letters.join}"

    guessed_letter = gets.chomp.downcase
    until @available_letters.include?(guessed_letter)
      puts "Invalid or unavailable letter. Try again:"
      guessed_letter = gets.chomp.downcase
    end
    puts

    @available_letters.delete(guessed_letter)
    guessed_letter
  end

  def check_guess(current_guess)
    puts "Please list indices of #{current_guess}. Format: 1 2 3"
    puts "Incorrect indices will be awarded to the other player. Don't cheat."
    puts "Leave blank if the letter is not in the word."

    indices = gets.chomp.split.map(&:to_i)
    puts

    indices
  end
end


class ComputerPlayer < Player
  def initialize(dictionary)
    super(dictionary)
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
  end

  def guess
    guessed_letter = @available_letters.sample
    @available_letters.delete(guessed_letter)
    guessed_letter
  end

  def check_guess(current_guess)
    @secret_word.split('').each_index.select { |i| @secret_word[i] == current_guess }
  end
end


class SmartComputerPlayer < ComputerPlayer
  def initialize(dictionary)
    @possible_words = []
    super(dictionary)
  end

  def guess
    frequent_letters = generate_frequent_letters

    current_guess = frequent_letters.shift[0]
    until @available_letters.include?(current_guess)
      current_guess = frequent_letters.shift[0]
    end

    @available_letters.delete(current_guess)
    current_guess
  end

  def get_guess_success(success, guess)
    if success
      @possible_words.select! { |word| word.include?(guess) }
    else
      @possible_words.reject! { |word| word.include?(guess) }
    end

    self
  end

  def check_guess(current_guess)
    @secret_word.split('').each_index.select { |i| @secret_word[i] == current_guess }
  end

  def get_secret_length(len)
    @secret_length = len
    @possible_words = @dictionary.select { |word| word.length == @secret_length }

    self
  end


  private

  def filter_possible_words(letter)
    if @possible_words.include?(letter)
      @possible_words.select! { |word| word.include?(letter) }
    else
      @possible_words.reject! { |word| word.include?(letter) }
    end

    self
  end

  def generate_frequent_letters
    same_layout = @possible_words.select { |word| similar_word?(@current_gamestate, word) }

    letter_map = Hash.new(0)
    same_layout.each do |word|
      word.each_char { |char| letter_map[char] += 1 }
    end
    letter_map.sort_by { |k, v| v }.reverse
  end

  def similar_word?(gamestate, word)
    return true if gamestate.all? { |letter| letter.nil? }

    @current_gamestate.each_with_index do |letter, i|
      unless letter.nil?
        return false unless letter == word[i]
      end
    end

    true
  end
end






p1 = HumanPlayer.new('dictionary.txt')
p2 = ComputerPlayer.new('dictionary.txt')
p3 = SmartComputerPlayer.new('dictionary.txt')

h = Hangman.new(p1, p3)
h.play