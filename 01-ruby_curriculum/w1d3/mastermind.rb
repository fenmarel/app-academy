class Array
  def unzip
    unzipped1 = []
    unzipped2 = []
    self.each do |x, y|
      unzipped1 << x
      unzipped2 << y
    end
    [unzipped1, unzipped2]
  end
end


class Code
  def initialize
    @secret_code = generate_secret
  end

  def solved?(guess)
    @secret_code == guess.split('')
  end

  def get_exact_and_near_guesses(guess)
    guess_arr = guess.split('')
    guess_secret_zip = guess_arr.zip(@secret_code)
    non_matching = guess_secret_zip.select { |x, y| x != y }
    exact_guess_count = 4 - non_matching.length

    sub_guess, sub_code = non_matching.unzip

    [exact_guess_count, parse_sub_codes(sub_code, sub_guess)]
  end


  private

  def generate_secret
    choices = %W(R O Y G B P)
    @secret_code = [].tap do |secret|
      4.times { secret << choices.sample }
    end
  end

  def parse_sub_codes(sub_code, sub_guess)
    near_guess_count = 0

    sub_guess.each do |guess|
      if sub_code.include?(guess)
        sub_code.delete_at(sub_code.index(guess))
        near_guess_count += 1
      end
    end
    near_guess_count
  end
end


class MasterMind
  def initialize(code)
    @turns_taken = 0
    @code = code
    @current_guess = ''
  end

  def play
    puts "*" * 25
    puts "* WELCOME TO MASTERMIND *"
    puts "*" * 25

    until @code.solved?(@current_guess)
      take_a_turn
    end

    puts "\nYou WIN!!! You took #{@turns_taken} turns!"
  end

  def take_a_turn
    puts "\nPlease guess a 4 digit code. [R O Y G B P]"

    new_guess = ''
    loop do
      new_guess = gets.chomp.upcase
      new_guess.length == 4 ? break : puts("Try again, must be 4 digits.")
    end

    @current_guess = new_guess
    @turns_taken += 1

    exact, near = @code.get_exact_and_near_guesses(@current_guess)
    puts "#{exact} of your colors are correct and correctly placed."
    puts "#{near} of your colors are correct, but in the wrong place"
  end
end


m = MasterMind.new(Code.new)
m.play