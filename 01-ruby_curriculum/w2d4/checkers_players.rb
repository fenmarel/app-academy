require './checkers_errors'

class Player
  attr_accessor :name, :color

  def initialize(color)
    @color = color
    @name = nil
  end
end


class HumanPlayer < Player
  def set_name(name)
    @name = name
  end

  def play_turn(moves, board)
    start = moves.first

    if board[start].color != @color || !board[start].valid_sequence?(moves)
      raise InvalidMoveError
    end

    board.move(moves)
  end
end