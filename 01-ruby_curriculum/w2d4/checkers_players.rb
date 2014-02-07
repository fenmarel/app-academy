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
    raise InvalidMoveError if board[moves.first].nil?
    raise InvalidMoveError if board[moves.first].color != @color
    raise InvalidMoveError if board[moves.first] == board[moves[1]]
    raise InvalidMoveError unless board[moves.first].valid_sequence?(moves)

    board.move(moves)
  end
end