require './checkers_pieces'

class CheckersBoard
  def initialize(new_board = true)
    @grid = Array.new(8) { Array.new(8) }
    set_board if new_board
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
          red_rows << CheckersPiece.new(:red, red_pos, self)
          black_rows << nil
        else
          red_rows << nil
          black_rows << CheckersPiece.new(:black, black_pos, self)
        end
      else
        if (i / 8).odd?
          red_rows << CheckersPiece.new(:red, red_pos, self)
          black_rows << nil
        else
          red_rows << nil
          black_rows << CheckersPiece.new(:black, black_pos, self)
        end
      end
    end


    @grid = red_rows.each_slice(8).to_a + blank_rows + black_rows.each_slice(8).to_a
    self
  end

  def display_board
    @grid.each do |row|
      row.each do |spot|
        spot.nil? ? print(" _ ") : print(" #{spot.color == :red ? 'R' : 'B'} ")
      end
      puts
    end

    self
  end
end


c = CheckersBoard.new
c.display_board