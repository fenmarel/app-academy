def rps(choice)
  options = { Rock: 1, Paper: 2, Scissors: 3 }
  
  computer_choice = options.keys.sample
  human_choice = choice.to_sym
  
  computer_num = options[computer_choice]
  human_num = options[human_choice]

  # Compare hands
  if human_num == computer_num
    puts "Computer chose #{computer_choice}, you tie!"
  elsif (human_num - computer_num) % 3 == 1
    puts "Computer chose #{computer_choice}, you win!"
  else
    puts "Computer chose #{computer_choice}, you lose!"
  end
end

# 5.times { rps("Rock") }