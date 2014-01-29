def queens(n)
  def check_diagonal_attacks(board)
    (0...board.length).each do |n|
      ((n+1)...board.length).each do |m|
        if board[n] + n == board[m] + m
          return false
        elsif board[n] - n == board[m] - m
          return false
        end
      end
    end
    true
  end

  def find_answers(n)
    possibles = (1..n).to_a.permutation.to_a
    
    [].tap do |solutions|
      possibles.each do |solution|
        if check_diagonal_attacks(solution) 
          solutions << solution
        end
      end
    end
  end
  find_answers(n)
end

p queens(4).count
p queens(8).count
