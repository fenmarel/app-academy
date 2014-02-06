module CheckersHelperMethods
  def move_type(start, finish)
    startx, starty = start
    finishx, finishy = finish

    check = [(startx - finishx).abs, (starty - finishy).abs]
    check == [1, 1] ? :slide : :jump
  end

  def space_between(start, finish)
    startx, starty = start
    finishx, finishy = finish

    [(startx + finishx) / 2, (starty + finishy) / 2]
  end

  def promote_pieces(finish, board)
    if board[finish].color == :black && finish[0] == 0
      board[finish].king_me
    elsif board[finish].color == :red && finish[0] == 7
      board[finish].king_me
    end
  end
end