#!/usr/bin/env ruby

class GuessingGame
  def initialize
    @answer = rand(1..100)
    @guess = 0
    @guesses = 0
  end
  
  def play
   puts '*' * 32
   puts '* WELCOME TO THE GUESSING GAME *'
   puts '*' * 32
   
   until won?
     puts "\nToo #{hint}, guess again." unless @guess == 0
     guess_a_number
     break if @guesses > 4
   end  
   
   puts win_or_lose   
  end
  
  def won?
    @guess == @answer
  end
  
  def hint
    @guess > @answer ? "high" : "low"
  end
  
  def guess_a_number
    puts "#{5 - @guesses} guesses left"
    print "Please guess a number between 1 and 100 > "
    @guess = gets.chomp.to_i
    @guesses += 1
  end
  
  def win_or_lose
    won? ? "Hooray, you win!!!" : "The number was #{@answer}, you lose!"
  end
end


if $PROGRAM_NAME == __FILE__
  g = GuessingGame.new
  g.play
end