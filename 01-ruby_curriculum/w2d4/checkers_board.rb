require './checkers_pieces'
require './checkers_helpers'

class CheckersBoard
  include CheckersHelperMethods

  def initialize(new_board = true)
    @grid = Array.new(8) { Array.new(8) }
    set_board if new_board
  end

  def move(moves)
    next_moves = moves.dup
    start = next_moves.shift

    until next_moves.empty?
      finish = next_moves.shift

      if move_type(start, finish) == :jump
        jumped_position = space_between(start, finish)
        self[jumped_position] = nil
      end

      move_step!(start, finish)
      start = finish
    end

    self
  end

  def move_step!(start, finish)
    self[finish] = self[start]
    self[finish].pos = finish
    self[start] = nil
  end

  def won?
    get_all_pieces(:black).empty? || get_all_pieces(:red).empty?
  end

  def get_all_pieces(color)
    pieces = @grid.flatten.compact
    pieces.select { |piece| piece.color == color }
  end


  def set_board
    red_rows = []
    black_rows = []
    blank_rows = Array.new(2) { Array.new(8) }

    24.times do |i|
      red_pos = [i / 8, i % 8]
      black_pos = [7 - (i / 8), i % 8]
      if i.odd?
        if (i / 8).even?
          set_piece(RedPiece.new(red_pos, self), red_pos)
          black_rows.unshift(nil)
        else
          red_rows << nil
          set_piece(BlackPiece.new(black_pos, self), black_pos)
        end
      else
        if (i / 8).odd?
          set_piece(RedPiece.new(red_pos, self), red_pos)
          black_rows.unshift(nil)
        else
          red_rows << nil
          set_piece(BlackPiece.new(black_pos, self), black_pos)
        end
      end
    end

    self
  end

  def set_piece(piece, position)
    self[position] = piece
  end

  def display_board
    @grid.each_with_index do |row, i|
      print "#{i} "
      row.each do |spot|
        spot.nil? ? print(" _ ") : print(" #{spot.color == :red ? 'R' : 'B'} ")
      end
      puts
    end
    puts "   0  1  2  3  4  5  6  7"
    self
  end

  def [](position)
    x, y = position
    @grid[x][y]
  end

  def []=(position, contents)
    x, y = position
    @grid[x][y] = contents
  end

  def dup
    new_board = CheckersBoard.new(false)
    current_pieces = @grid.flatten.compact

    current_pieces.each do |piece|
      new_board[piece.pos] = piece.class.new(piece.pos, new_board)
    end

    new_board
  end

end



if $PROGRAM_NAME == __FILE__
  c = CheckersBoard.new
  c.move([[2, 1], [3, 2], [4, 3]])
  # p c.get_all_pieces(:red).map(&:pos)
  # p c[[5, 4]].available_jumps
  c.display_board
end