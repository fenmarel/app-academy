require './chess_pieces'
require './chessboard'
require './chess_players'
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
    @player1 = ComputerPlayer.new(:white, @board)
    @player2 = ComputerPlayer.new(:black, @board)
    @curr_player = @player1
    @piece_to_move = nil
    @computer_names = %W(Bubba Stu Sue Frank Barbara Belle Cleatus)
  end

  def play
    puts "Would you like to load a game? (y/n)"
    ans = gets.chomp!.downcase
    if ans[0] == 'y'
      load_game_prompts
    else
      set_name(@player1)
      set_name(@player2)
    end

    redraw_board
    until @board.checkmate?(@curr_player.color)
      alternate_turns
    end

    redraw_board
    winner = @curr_player == @player1 ? @player2 : @player1
    puts "#{winner.name} wins!"
  end

  def set_name(player)
    if player.is_a?(HumanPlayer)
      puts "Enter Player's name: "
      player.name = gets.chomp!
    else
      player.name = "Computer #{@computer_names.shuffle.pop}"
    end

    self
  end

  def load_game_prompts
    puts "Enter filename:"
    filename = gets.chomp!
    contents = File.read(filename)
    saved_game = YAML::load(contents)

    @board = saved_game.board
    @player1 = saved_game.player1
    @player2 = saved_game.player2
    @curr_player = saved_game.curr_player

    self
  end

  def alternate_turns
    begin
      if @curr_player.is_a?(ComputerPlayer)
        @curr_player.play_turn
        switch_player
      else
        navigate_and_select
      end
      redraw_board
    rescue StandardError => e
      p e.message
      return
    end
  end

  def switch_player
    @curr_player = @curr_player == @player1 ? @player2 : @player1

    self
  end

  def navigate_and_select
    redraw_board
    puts "#{@curr_player.name}'s Turn"
    puts "CHECK!" if @board.in_check?(@curr_player.color)
    char = nil

    until /[wsadq\s]/i =~ char
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
          lift_or_drop_piece
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

  def lift_or_drop_piece
    if !@piece_to_move.nil?
      @curr_player.play_turn(@piece_to_move, @board.cursor)
      switch_player
      @piece_to_move = nil
      @board.highlighted = []
    elsif !@board[@board.cursor].nil?
      @piece_to_move = @board.cursor
      @board.highlighted = @board[@piece_to_move].valid_moves(@board)
    end

    self
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



g = Game.new

g.play