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
      rescue TypeError => e
        puts 'invalid move format'
        retry
      end

      switch_player
    end
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

c = Checkers.new
c.play