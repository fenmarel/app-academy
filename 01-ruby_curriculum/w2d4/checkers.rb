require './checkers_board'
require './checkers_pieces'
require './checkers_players'

class Checkers
  def initialize
    @board = CheckersBoard.new
    @player1 = HumanPlayer.new(:black)
    @player2 = HumanPlayer.new(:red)
    @current_player = @player1
  end

  def play
    until @board.won?
      @board.display_board

      begin
        @current_player.take_turn(@board)
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
    end
  end
end

c = Checkers.new
c.play