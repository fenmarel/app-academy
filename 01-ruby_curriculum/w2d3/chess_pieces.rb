# coding: utf-8

class Piece
  attr_reader :color, :pos, :icon
  attr_accessor :turns_moved, :board

  HORIZONTALS = [[0,1], [0,-1], [1,0], [-1,0]]
  DIAGONALS = [[1,1], [-1,-1], [1,-1], [-1,1]]

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @turns_moved = 0
    @move_dir = []
  end

  def moves
    # assure all child types handle their own move specifics
    raise "method not implemented"
  end

  def valid_moves(board)
    possible_moves = self.moves
    start_pos = @pos.dup

    possible_moves.select do |end_pos|
      board_copy = board.dup
      board_copy[end_pos] = board_copy[start_pos]
      board_copy[end_pos].update_position(end_pos)
      board_copy[start_pos] = nil
      !board_copy.in_check?(@color)
    end
  end

  def inbound?(pos)
    pos.all? { |dim| dim.between?(0, 7) }
  end

  def inspect
    "Piece: #{self.class} | Color: #{@color} | Pos: #{@pos}"
  end

  def dup
    self.class.new(@color, @pos.dup, @board)
  end

  def update_position(pos)
    @pos = pos.dup
  end
end

class SlidingPiece < Piece
  def initialize(color, pos, board)
    super
  end

  def moves
    valid_positions = []

    @move_dir.each do |row, col|
      new_pos = @pos.dup
      new_pos[0] += row
      new_pos[1] += col

      while inbound?(new_pos)
        unless @board[new_pos].nil?
          if @board[new_pos].color != @color
            valid_positions << new_pos.dup
          end

          break
        end

        valid_positions << new_pos.dup
        new_pos[0] += row
        new_pos[1] += col
      end
    end

    valid_positions
  end
end

class SteppingPiece < Piece
  def initialize(color, pos, board)
    super
  end

  def moves
    valid_positions = []

    @move_dir.each do |row, col|
      new_pos = @pos.dup
      new_pos[0] += row
      new_pos[1] += col

      if inbound?(new_pos)
        if @board[new_pos].nil?
          valid_positions << new_pos.dup
        elsif @board[new_pos].color != @color
          valid_positions << new_pos.dup
        end
      end
    end

    valid_positions
  end
end

class BlackPawn < Piece # switch back to Piece
  def initialize(color, pos, board)
    super
    @move_dir = [[1, 0], [2, 0]]
    @icon = '♟'
  end

  def moves
    valid_positions = []

    unless @turns_moved == 0
      @move_dir = [[1, 0]]
    end

    unless @pos[1] == 7
      check_pos = [@pos[0] + 1, @pos[1] + 1]
      unless @board[check_pos].nil? || @board[check_pos].color == @color
        valid_positions << check_pos
      end
    end

    unless @pos[1] == 0
      check_pos = [@pos[0] + 1, @pos[1] - 1]
      unless @board[check_pos].nil? || @board[check_pos].color == @color
        valid_positions << check_pos
      end
    end

    @move_dir.each do |row, col|
      new_pos = @pos.dup
      new_pos[0] += row
      new_pos[1] += col

      if inbound?(new_pos)
        if @board[new_pos].nil? && @board[[@pos[0] + 1, @pos[1]]].nil?
          valid_positions << new_pos.dup
        end
      end
    end

    valid_positions
  end
end

class WhitePawn < Piece
  def initialize(color, pos, board)
    super
    @move_dir = [[-1, 0], [-2, 0]]
    @icon = '♙'
  end

  def moves
    valid_positions = []

    unless @turns_moved == 0
      @move_dir = [[-1, 0]]
    end

    unless @pos[1] == 7
      check_pos = [@pos[0]-1, @pos[1]+1]
      unless @board[check_pos].nil? || @board[check_pos].color == @color
        valid_positions << check_pos
      end
    end

    unless @pos[1] == 0
      check_pos = [@pos[0]-1, @pos[1]-1]
      unless @board[check_pos].nil? || @board[check_pos].color == @color
        valid_positions << check_pos
      end
    end

    @move_dir.each do |row, col|
      new_pos = @pos.dup
      new_pos[0] += row
      new_pos[1] += col

      if inbound?(new_pos)
        if @board[new_pos].nil? && @board[[@pos[0] - 1, @pos[1]]].nil?
          valid_positions << new_pos.dup
        end
      end
    end

    valid_positions
  end
end

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super
    @move_dir = HORIZONTALS + DIAGONALS
    @icon = @color == :white ? '♕' : '♛'
  end
end

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super
    @move_dir = DIAGONALS
    @icon = @color == :white ? '♗' : '♝'
  end
end

class Rook < SlidingPiece
  def initialize(color, pos, board)
    super
    @move_dir = HORIZONTALS
    @icon = @color == :white ? '♖' : '♜'
  end
end

class Knight < SteppingPiece
  def initialize(color, pos, board)
    super
    @move_dir = [[2, 1], [1, 2], [-1, 2], [-2, -1],
                 [-2, 1], [-1, -2], [1, -2], [2, -1]]
    @icon = @color == :white ? '♘' : '♞'
  end
end

class King < SteppingPiece
  def initialize(color, pos, board)
    super
    @move_dir = DIAGONALS + HORIZONTALS
    @icon = @color == :white ? '♔' : '♚'
  end
end