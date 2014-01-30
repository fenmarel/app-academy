Pos = Struct.new(:x, :y)

class Board
  attr_reader :board, :winner

  def initialize
    @board = Array.new(3) { |i| Array.new(3, nil) }
  end

  def won?
    possible_wins = @board + @board.transpose
    possible_wins << [@board[0][0], @board[1][1], @board[2][2]]
    possible_wins << [@board[0][2], @board[1][1], @board[2][0]]
    
    possible_wins.each do |possibility|
      return true if check_win(possibility)
    end
    false
  end

  def check_win(possible_win)
    if possible_win.all? { |check| check == 'X' } ||
       possible_win.all? { |check| check == 'O' }
      @winner = possible_win.first
      return true
    end
    false
  end

  def empty?(pos)
    @board[pos.x][pos.y].nil?
  end

  def place_mark(pos, mark)
    @board[pos.x][pos.y] = mark
  end

  def display_board
    puts "   0   1   2"
    @board.each_with_index do |row, dex|
      print "#{dex} "
      row.each do |spot|
        print "[#{spot || ' '}] "
      end
      puts
    end
    puts
  end

  def tie?
    @board.each do |row|
      row.each do |val|
        return false if val.nil?
      end
    end
    true
  end
end

class Game
  def play
    board = Board.new
    players = [HumanPlayer.new('X'), ComputerPlayer.new('O', board)]
    player_index = 0

    board.display_board

    until board.won? || board.tie?
      current_player = players[player_index]
      
      pos = current_player.make_move
      until board.empty?(pos)
        pos = current_player.make_move
      end

      board.place_mark(pos, current_player.mark)
      player_index = (player_index + 1) % 2
      board.display_board
    end
      
    board.won? ? puts("#{board.winner} Won!") : puts("You Tied!")
  end
end

class Player
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end
end

class HumanPlayer < Player
  def make_move
    puts "Enter a position for #{self.mark}. (row column)"
    mark = gets.chomp.split(' ').map(&:to_i)
    Pos.new(mark[0], mark[1])
  end
end

class ComputerPlayer < Player
  def initialize(mark, board)
    super(mark)
    @board = board
  end

  def make_move
    @board.board.each_with_index do |row, dex1|
      row.each_with_index do |col, dex2|
        if col.nil?
          test_pos = Pos.new(dex1, dex2)
          @board.place_mark(test_pos, self.mark)
          if @board.won?
            @board.place_mark(test_pos, nil)
            return test_pos
          else
            @board.place_mark(test_pos, nil)
          end
        end
      end
    end
    
    Pos.new(rand(0..2), rand(0..2))
  end
end


g = Game.new
g.play
