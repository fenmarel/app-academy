def change_option(amt, coins)
  return [] if amt == 0 || coins.empty?

  change = []
  coin = coins.first
  remainder = amt % coin

  num_of_coins = amt / coin
  num_of_coins.times { change << coin }

  change += change_option(remainder, coins.drop(1))
end

def make_change(amt, coins=[25, 10, 5, 1])
  possibles = []
  coins.length.times do
    possibles << change_option(amt, coins.drop(1))
  end

  possibles = possibles.sort_by { |x| x.length }
  until possibles.empty?
    check = possibles.shift
    return check if check.inject(:+) == amt
  end

 []
end


# p make_change(0) # []
# p make_change(1) # [1]
# p make_change(5) # [5]
# p make_change(10) # [10]
# p make_change(25) # [25]
# p make_change(42) # [25, 10, 5, 1, 1]

# p make_change(14, [10, 7]) # [7, 7]
# p make_change(9999999) # for the sake of efficiency checking
