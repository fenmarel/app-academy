require './checkers_board'
require './checkers_pieces'
require './checkers_players'
require 'io/console'

class Checkers
  def initialize
    @board = CheckersBoard.new
    @player1 = HumanPlayer.new(:black)
    @player2 = HumanPlayer.new(:red)
    @current_player = @player1
    @current_move_chain = []
  end

  def play
    puts "Welcome to Checkers"

    until @board.won?
      @board.display_board

      navigate_and_select

    end
  end

  def navigate_and_select
    redraw_board
    puts "#{@current_player.color}'s Turn"
    char = nil

    until /[wsadfq\s]/i =~ char
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
          add_to_chain unless @current_move_chain.last == @board.cursor
        elsif char == 'f'
          add_to_chain unless @current_move_chain.last == @board.cursor
          raise InvalidMoveError if @current_move_chain.length < 2

          @current_player.play_turn(@current_move_chain, @board)
          @current_move_chain = []
          switch_player
        elsif char == 'q'
          raise ForceEndGame
        end

      rescue InvalidMoveError => e
        puts e.message
        @current_move_chain = []
        retry
      rescue ForceEndGame => e
        abort(e.message)
      end
    end
  end

  def redraw_board
    system 'clear'
    @board.display_board
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

  def add_to_chain
    @current_move_chain << @board.cursor
  end

  def lift_or_drop_piece
    if !@piece_to_move.nil?
      @current_player.play_turn(@piece_to_move, @board.cursor)
      switch_player
      @piece_to_move = nil
      @board.highlighted = []
    elsif !@board[@board.cursor].nil?
      @piece_to_move = @board.cursor
    end
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

c = Checkers.new
c.play