require './chess_pieces'
require 'colorize'

class Board
  attr_accessor :cursor, :highlighted

  def initialize
    @board_state = Array.new(8) { Array.new(8) }
    self.set_board
    @cursor = [6, 0]
    @highlighted = []
  end

  def show_board
    white = true

    puts "   a  b  c  d  e  f  g  h"
    @board_state.each_with_index do |row, i|
      print "#{8 - i} "
      row.each_with_index do |col, j|
        if [i, j] == @cursor
          col.nil? ? print("   ".on_red) : print(" #{col.icon} ".on_red)
          white = !white
        elsif @highlighted.include?([i, j])
          col.nil? ? print("   ".on_yellow) : print(" #{col.icon} ".on_yellow)
          white = !white
        else
          if white
            col.nil? ? print("   ".on_blue) : print(" #{col.icon} ".on_blue)
            white = !white
          else
            col.nil? ? print("   ") : print(" #{col.icon} ")
            white = !white
          end
        end
      end
      white = !white
      puts " #{8 - i}"
    end
    puts "   a  b  c  d  e  f  g  h"
    puts "\nUse wsad to move, q to quit and save"
    puts "Spacebar to grab/drop pieces."
  end

  def set_board
    set_pawns
    set_first_rank_pieces(:black)
    set_first_rank_pieces(:white)

    self
  end

  def set_pawns
    @board_state[1].each_with_index do |place, i|
      self[[1, i]] = BlackPawn.new(:black, [1, i], self)
    end

    @board_state[6].each_with_index do |place, i|
      self[[6,i]] = WhitePawn.new(:white, [6, i], self)
    end

    self
  end

  def set_first_rank_pieces(color)
    row = color == :white ? 7 : 0
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    pieces.each_with_index do |piece, i|
      self[[row, i]] = piece.new(color, [row, i], self)
    end

    self
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def in_check?(color)
    opposing_color = other_color(color)
    opposing_pieces = get_pieces(opposing_color)
    opposing_pieces.each do |piece|
      piece_moves = piece.moves
      return true if piece_moves.include?(find_king(color))
    end

    false
  end

  def get_pieces(color)
    pieces = []

    @board_state.each do |row|
      row.each do |piece|
        next if piece.nil?
        pieces << piece if piece.color == color
      end
    end

    pieces
  end

  def score(color)
    values = { "BlackPawn" => 1, "WhitePawn" => 1, "Knight" => 3,
               "Bishop" => 3, "Rook" => 5, "Queen" => 9, "King" => 4 }

    pieces = get_pieces(color)
    enemy_pieces = get_pieces(other_color(color))

    score = 0
    pieces.each do |piece|
      score += values[piece.class.to_s]
    end

    enemy_pieces.each do |piece|
      score -= values[piece.class.to_s]
    end

    score
  end

  def find_king(color)
    @board_state.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color != color
        return piece.pos if piece.is_a?(King)
      end
    end

    raise "no king of that color found."
  end

  def move(start, finish)
    raise InvalidMoveError if self[start].nil?

    possible_moves = self[start].valid_moves(self)
    raise InvalidMoveError unless possible_moves.include?(finish)

    self[finish] = self[start]
    self[start] = nil
    self[finish].update_position(finish)
    self[finish].turns_moved += 1
  end

  def checkmate?(color)
    pieces_left = get_pieces(color)

    pieces_left.each do |piece|
      return false unless piece.valid_moves(self).empty?
    end

    true
  end

  def []=(pos, piece)
    @board_state[pos[0]][pos[1]] = piece
  end

  def [](pos)
    @board_state[pos[0]][pos[1]]
  end

  def dup
    new_board = Board.new

    @board_state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        unless piece.nil?
          new_board[[i, j]] = piece.dup
          new_board[[i, j]].board = new_board
        else
          new_board[[i, j]] = nil
        end
      end
    end

    new_board
  end
end