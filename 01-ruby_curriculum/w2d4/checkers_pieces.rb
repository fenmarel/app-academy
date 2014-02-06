require './checkers_helpers'

class CheckersPiece
  include CheckersHelperMethods

  attr_reader :color
  attr_accessor :pos

  def initialize(pos, board)
    @color = nil
    @pos = pos
    @board = board
    @king = false
    @slide_move_diffs = []
    @jump_move_diffs = []
  end

  def valid_sequence?(moves)
    possible_steps = moves.drop(1)
    start = @pos.dup
    current_board = @board.dup

    until possible_steps.empty?
      next_step = possible_steps.shift

      # prevent multiple slides
      if move_type(start, next_step) == :slide && !possible_steps.empty?
        return false
      end

      if valid_step?(start, next_step, current_board)
        current_board.move_step!(start, next_step)
      else
        return false
      end

      start = next_step
    end

    true
  end

  def valid_step?(start, finish, board)
    return false if board[start].nil?
    all_moves = board[start].available_slides + board[start].available_jumps
    all_moves.include?(finish)
  end

  def available_slides
    slides = []
    posx, posy = @pos

    @slide_move_diffs.each do |dx, dy|
      slides << [posx + dx, posy + dy]
    end

    slides.select! { |x, y| x.between?(0, 7) && y.between?(0, 7) }
    slides.select { |pos| @board[pos].nil? }
  end

  def available_jumps
    jumps = []
    posx, posy = @pos

    @jump_move_diffs.each do |dx, dy|
      jumps << [posx + dx, posy + dy]
    end

    jumps.select! { |x, y| x.between?(0, 7) && y.between?(0, 7) }
    jumps.select do |possible|
      between = space_between(@pos, possible)

      @board[possible].nil? &&
      !@board[between].nil? &&
      @board[between].color != @color
    end
  end
end



class RedPiece < CheckersPiece
  def initialize(pos, board)
    super
    @color = :red
    @slide_move_diffs = [[1, 1], [1, -1]]
    @jump_move_diffs = [[2, 2], [2, -2]]
  end
end

class BlackPiece < CheckersPiece
  def initialize(pos, board)
    super
    @color = :black
    @slide_move_diffs = [[-1, 1], [-1, -1]]
    @jump_move_diffs = [[-2, 2], [-2, -2]]
  end
end






