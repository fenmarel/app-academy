require './chess_pieces'
require './chessboard'

class InvalidMoveError < StandardError
  attr_reader :message

  def initialize
    @message = "invalid move!"
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white, @board)
    @player2 = HumanPlayer.new(:black, @board)
    @curr_player = @player1
  end

  def play
    puts "Enter Player1's name: "
    @player1.name = gets.chomp!
    puts "Enter Player2's name: "
    @player2.name = gets.chomp!

    until @board.checkmate?(@curr_player.color)
      system 'clear'
      @board.show_board
      @curr_player.play_turn
      @curr_player = @curr_player == @player1 ? @player2 : @player1
    end

    system 'clear'
    @board.show_board

    winner = @curr_player == @player1 ? @player2 : @player1
    puts "#{winner.name} wins!"
  end
end

class Player
  attr_reader :color
  attr_accessor :name

  ROW_NUMS = %w(8 7 6 5 4 3 2 1)
  COL_LETTERS = %w(a b c d e f g h)

  def initialize(color, board)
    @name = nil
    @color = color
    @board = board
  end
end

class HumanPlayer < Player
  def play_turn
    begin
      # get user input for piece and move start/finish
      puts "Select a piece: "
      start_pos = gets.chomp!
      start_pos = [ROW_NUMS.index(start_pos[1]), COL_LETTERS.index(start_pos[0])]

      raise InvalidMoveError if start_pos[1].nil? || start_pos[0].nil?
      raise InvalidMoveError unless @board.get_pieces(@color).include?(@board[start_pos])

      puts "Specify a destination: "
      end_pos = gets.chomp!
      end_pos = [ROW_NUMS.index(end_pos[1]), COL_LETTERS.index(end_pos[0])]

      raise InvalidMoveError if end_pos[1].nil? || end_pos[0].nil?

      @board.move(start_pos, end_pos)
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end
end


g = Game.new

g.play
