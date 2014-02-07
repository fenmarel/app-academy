# coding: utf-8

require './checkers_helpers'
require 'colorize'

class CheckersPiece
  include CheckersHelperMethods

  attr_reader :color, :icon, :king
  attr_accessor :pos

  def initialize(pos, board, king=false)
    @icon = nil
    @color = nil
    @pos = pos
    @board = board
    @king = king
    @slide_move_diffs = []
    @jump_move_diffs = []
  end

  def king_me
    @king = true
    @slide_move_diffs = [[-1, 1], [-1, -1], [1, -1], [1, 1]]
    @jump_move_diffs = [[-2, 2], [-2, -2], [2, -2], [2, 2]]
  end

  def valid_sequence?(moves)
    possible_steps = moves.drop(1)
    start = @pos.dup
    current_board = @board.dup

    until possible_steps.empty?
      next_step = possible_steps.shift

      if move_type(start, next_step) == :slide && !possible_steps.empty?
        return false
      end

      if valid_step?(start, next_step, current_board)
        current_board.move_step!(start, next_step)
      else
        return false
      end

      promote_pieces(next_step, current_board)
      start = next_step
    end

    true
  end

  def available_slides
    slides = []
    posx, posy = @pos

    @slide_move_diffs.each do |dx, dy|
      slides << [posx + dx, posy + dy]
    end

    slides.select! { |slide_position| inbounds?(slide_position) }
    slides.select { |slide_position| @board[slide_position].nil? }
  end

  def available_jumps
    jumps = []
    posx, posy = @pos

    @jump_move_diffs.each do |dx, dy|
      jumps << [posx + dx, posy + dy]
    end

    jumps.select! { |jump_position| inbounds?(jump_position) }
    jumps.select do |jump_position|
      between = space_between(@pos, jump_position)

      @board[jump_position].nil? &&
      !@board[between].nil? &&
      @board[between].color != @color
    end
  end


  private

  def valid_step?(start, finish, board)
    return false if board[start].nil?

    all_moves = board[start].available_slides + board[start].available_jumps
    all_moves.include?(finish)
  end

  def inbounds?(position)
    posx, posy = position
    posx.between?(0, 7) && posy.between?(0, 7)
  end
end



class RedPiece < CheckersPiece
  def initialize(pos, board, king=false)
    super
    @icon = ' ◉ '.red.on_white
    @color = :red
    @slide_move_diffs = [[1, 1], [1, -1]]
    @jump_move_diffs = [[2, 2], [2, -2]]

    king_me if king
  end

  def king_me
    super
    @icon = ' ✪ '.red.on_white

    self
  end
end

class BlackPiece < CheckersPiece
  def initialize(pos, board, king=false)
    super
    @icon = ' ◉ '.black.on_white
    @color = :black
    @slide_move_diffs = [[-1, 1], [-1, -1]]
    @jump_move_diffs = [[-2, 2], [-2, -2]]

    king_me if king
  end

  def king_me
    super
    @icon = ' ✪ '.black.on_white

    self
  end
end






