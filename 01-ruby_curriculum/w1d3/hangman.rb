class Hangman
  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player
    @checking_player = checking_player
    @secret_word = ''
    @gamestate = []
    @max_turns = @turns_left = 10
  end

  def play
    @secret_word = @checking_player.pick_secret_word
    @guessing_player.update_word_length(@secret_word.length)

    @guessing_player.get_secret_word(@secret_word)

    # clear the display for human vs human
    system "clear"

    until game_over?
      take_a_turn
    end

    won? ? print_win_message : print_lose_message
    sleep(5)
  end

  def update_gamestate(indices, letter)
    indices.each { |i| @gamestate[i] = letter }
  end

  def show_gamestate
    @secret_word.length.times do |i|
      @gamestate[i].nil? ? print("_ ") : print("#{@gamestate[i]} ")
    end
    puts

    @secret_word.length.times do |i|
      print "#{i} "
    end
    puts "\n\n"
  end

  def game_over?
    won? || @turns_left == 0
  end

  def won?
    @secret_word == @gamestate.join
  end

  def print_win_message
    puts "Congratulations, you win!"
    puts "The word was #{@secret_word}!"
    puts "You took #{@max_turns - @turns_left} turns, with #{@turns_left} left."
  end

  def print_lose_message
    puts "Hang 'em high! You lose!"
    puts "The word was #{@secret_word}!"
  end

  def take_a_turn
    puts "Hangman! You have #{@turns_left} turns left."
    show_gamestate

    guess = @guessing_player.guess
    guess_indices = @checking_player.report_found_letters(guess)

    update_gamestate(guess_indices, guess)
    @guessing_player.get_gamestate(@gamestate)

    @turns_left -= 1 if guess_indices.empty?
    system "clear"
  end
end



class Player
  def initialize(dictionary)
    @vocabulary = File.read(dictionary).gsub(/[-']/, '').split("\n")
    @guesses = []
    @secret_word = ''
    @possible_words = nil
    @word_length = 0
    @gamestate = []
  end

  def update_word_length(length)
    @word_length = length
  end

  def get_secret_word(word)
    @secret_word = word
  end

  def get_gamestate(gamestate)
    @gamestate = gamestate
  end
end


class HumanPlayer < Player
  def pick_secret_word
    puts "Please input your secret word."
    secret = ''

    loop do
      secret = gets.chomp

      break if @vocabulary.include?(secret)
      puts("Try again, must be a known word.")
    end

    @secret_word = secret
  end

  def guess
    puts "Guess a letter"
    puts "You have guessed #{@guesses.sort}" unless @guesses.empty?
    guessed_letter = gets.chomp

    while @guesses.include?(guessed_letter)
      puts "You already guessed that letter, try again."
      guessed_letter = gets.chomp
    end

    @guesses << guessed_letter
    guessed_letter
  end

  def report_found_letters(letter)
    puts "Please report indices of the letter #{letter}. (eg 1 2 5)"
    puts "Leave blank if letter is not in word."
    gets.chomp.split.map(&:to_i)
  end
end


class ComputerPlayer < Player
  def pick_secret_word
    @secret_word = @vocabulary.sample
  end

  def guess
    @possible_words ||= populate_possible_words

    most_frequent_valid_letter = get_most_frequent_letter

    if @secret_word.include?(most_frequent_valid_letter)
      update_possible_words!(most_frequent_valid_letter)
    else
      remove_impossible_words!(most_frequent_valid_letter)
    end

    @guesses << most_frequent_valid_letter
    most_frequent_valid_letter
  end

  def report_found_letters(letter)
    @secret_word.split('').each_index.select { |i| @secret_word[i] == letter }
  end


  private

  def populate_possible_words
    @possible_words = @vocabulary.select { |word| word.length == @word_length }
  end

  def update_possible_words!(letter)
    @possible_words.select! { |word| word.include?(letter) }
  end

  def remove_impossible_words!(letter_not_in_word)
    @possible_words.select! { |word| not word.include?(letter_not_in_word) }
  end

  def get_most_frequent_letters
    letter_map = Hash.new(0)

    @possible_words.each do |word|
      word.each_char do |char|
        letter_map[char] += 1
      end
    end

    sorted_letters = letter_map.sort_by { |letter, num| num }
    sorted_letters.map { |letter, num| letter }.reverse
  end

  def get_most_frequent_letter
    frequent_letters = get_most_frequent_letters
    frequent_letters.each do |letter|
      unless @guesses.include?(letter)
        return letter
      end
    end
  end
end


hp = HumanPlayer.new('dictionary.txt')
cp = ComputerPlayer.new('dictionary.txt')
h = Hangman.new(cp, hp)
h.play