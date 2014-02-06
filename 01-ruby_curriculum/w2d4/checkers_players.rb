class InvalidMoveError < RuntimeError
  def initialize
    @message = "invalid move."
  end
end

class Player
  attr_accessor :name

  def initialize(color)
    @color = color
    @name = nil
  end
end


class HumanPlayer < Player
  def set_name(name)
    @name = name
  end

  def take_turn(board)
    puts "Enter move sequence >> Format: [1, 2], [3, 4]"
    moves = gets.gsub(/[\[\]]/, '').split(',').map(&:to_i).each_slice(2).to_a
    raise InvalidMoveError if board[moves.first].nil?
    raise InvalidMoveError if board[moves.first].color != @color
    raise InvalidMoveError unless board[moves.first].valid_sequence?(moves)

    board.move(moves)
  end
end