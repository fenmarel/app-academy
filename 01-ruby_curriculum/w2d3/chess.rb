require './chess_pieces'
require './chessboard'
require 'colorize'
require 'io/console'
require 'yaml'

class InvalidMoveError < StandardError
  attr_reader :message

  def initialize
    @message = "invalid move!"
  end
end

class Game
  attr_accessor :board, :player1, :player2, :curr_player
  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white, @board)
    @player2 = HumanPlayer.new(:black, @board)
    @curr_player = @player1
    @piece_to_move = nil
  end

  def play
    puts "Would you like to load a game? (y/n)"
    ans = gets.chomp!.downcase.split('')
    if ans[0] == 'y'
      puts "Enter filename:"
      filename = gets.chomp!
      contents = File.read(filename)
      saved_game = YAML::load(contents)
      @board = saved_game.board
      @player1 = saved_game.player1
      @player2 = saved_game.player2
      @curr_player = saved_game.curr_player
    else
      puts "Enter Player1's name: "
      @player1.name = gets.chomp!
      puts "Enter Player2's name: "
      @player2.name = gets.chomp!
    end

    until @board.checkmate?(@curr_player.color)
      begin
        navigate_and_select
      rescue StandardError => e
        return
      end
    end

    system 'clear'
    @board.show_board

    winner = @curr_player == @player1 ? @player2 : @player1
    puts "#{winner.name} wins!"
  end

  def navigate_and_select
    redraw_board
    puts "#{@curr_player.name}'s Turn"
    puts "CHECK!" if @board.in_check?(@curr_player.color)
    char = nil

    until /[wsadqf\s]/i =~ char
      begin
        char = STDIN.getch

        if char == 'w'
          move(:up)
        elsif char == 'a'
          move(:left)
        elsif char == 's'
          move(:down)
        elsif char == 'd'
          move(:right)
        elsif char == ' '
          @piece_to_move = @board.cursor
        elsif char == 'f'
          unless @piece_to_move.nil?
            @curr_player.play_turn(@piece_to_move, @board.cursor)
            @curr_player = @curr_player == @player1 ? @player2 : @player1
            @piece_to_move = nil
          end
        elsif char == 'q'
          File.open(save_as, 'w') { |f| f.puts self.to_yaml }
        end

      rescue InvalidMoveError => e
        puts e.message
        @piece_to_move = nil
        retry
      end
    end
  end

  def redraw_board
    system 'clear'
    @board.show_board
  end

  def save_as
    puts "Please input a name for your saved game:"
    puts "Press enter to quit without saving."
    gets.chomp!
  end

  def move(direction)
    if direction == :up
      @board.cursor = [((@board.cursor[0]-1) % 8), @board.cursor[1]]
    elsif direction == :down
      @board.cursor = [((@board.cursor[0]+1) % 8), @board.cursor[1]]
    elsif direction == :left
      @board.cursor = [(@board.cursor[0]), ((@board.cursor[1]-1) % 8)]
    elsif direction == :right
      @board.cursor = [(@board.cursor[0]), ((@board.cursor[1]+1) % 8)]
    end
  end
end

class Player
  attr_reader :color
  attr_accessor :name

  def initialize(color, board)
    @name = nil
    @color = color
    @board = board
  end
end

class HumanPlayer < Player
  def play_turn(start_pos, end_pos)
    raise InvalidMoveError if start_pos[1].nil? || start_pos[0].nil?
    raise InvalidMoveError unless @board.get_pieces(@color).include?(@board[start_pos])
    raise InvalidMoveError if end_pos[1].nil? || end_pos[0].nil?

    @board.move(start_pos, end_pos)
  end
end



g = Game.new

g.play

