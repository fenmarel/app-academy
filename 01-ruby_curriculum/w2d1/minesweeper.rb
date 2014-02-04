require 'yaml'
require 'colorize'

class Tile
  attr_reader :symbol, :is_bomb, :revealed, :flagged

  def initialize(is_bomb, coordinate)
    @is_bomb = is_bomb
    @coordinate = coordinate
    @revealed = false
    @flagged = false
    @symbol = '*'
  end

  def reveal(grid)
    unless @revealed || @flagged
      @revealed = true
      if @is_bomb
        @symbol = 'b'.red
      else
        @symbol = neighbor_bomb_count(grid).to_s.cyan
        if @symbol == '0'.cyan
          @symbol = '_'
          reveal_neighbors(grid)
        end
      end
    end

    self
  end

  def flag(grid)
    unless @revealed
      @flagged = !@flagged
      @symbol = @symbol == 'F'.yellow ? '*' : 'F'.yellow
    end

    self
  end


  private

  def reveal_neighbors(grid)
    surrounding_positions = neighbors(grid)

    surrounding_positions.each do |x,y|
      unless grid[x][y].revealed
        grid[x][y].reveal(grid)
      end
    end

    self
  end

  def neighbors(grid)
    surrounding_positions = []
    position_changes = [[-1,-1], [-1, 0], [-1, 1],
                         [0,-1],           [0,1],
                         [1,-1],  [1,0],   [1,1]]

    position_changes.each do |x,y|
      surrounding_positions << [@coordinate[0] + x, @coordinate[1] + y]
    end

    surrounding_positions.select do |x,y|
      x >= 0 && y >= 0 && x < grid.length && y < grid.length
    end
  end

  def neighbor_bomb_count(grid)
    array_of_tilepos = neighbors(grid)
    count = 0

    array_of_tilepos.each do |x,y|
      count += 1 if grid[x][y].is_bomb
    end

    count
  end
end

class Board
  attr_reader :grid

  def initialize(size)
    @size = size
    @grid = Array.new(@size) { Array.new(@size)}
    @cursor = [0,0]
    @leaderboard = load_leaderboard
  end

  def load_leaderboard
    if File.exist?('leaderboard')
      YAML::load(File.read('leaderboard').chomp)
    else
      LeaderBoard.new
    end
  end

  def set_board
    @grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        @grid[i][j] = Tile.new(rand() < 0.15, [i,j])
      end
    end
  end

  def play
    puts "Press enter for New Game or Type L for Load game"
    if gets.chomp == "L"
      puts "What was the name of your saved game?"
      filename = gets.chomp
      @grid = YAML::load(File.read(filename).chomp)
      @size = @grid.length
    else
      set_board
    end

    until over?
      navigate_and_select
    end

    if won?
      redraw_board
      puts "You found all the bombs and won!"
    else
      reveal_bombs
      puts "You lose, try again." unless won?
    end
  end

  def navigate_and_select
    redraw_board
    system("stty raw -echo")
    char = STDIN.read_nonblock(1) rescue nil
    system("stty -raw echo")

    if /[wsadrfq]/i =~ char
      if char == 'w'
        move(:up)
      elsif char == 'a'
        move(:left)
      elsif char == 's'
        move(:down)
      elsif char == 'd'
        move(:right)
      elsif char == 'f'
        self[@cursor].flag(@grid)
      elsif char == 'r'
        self[@cursor].reveal(@grid)
      elsif char == 'q'
        File.open(save_as, 'w') { |f| f.puts @grid.to_yaml }
        return
      end

      sleep(0.1)
    end

    self
  end

  def move(direction)
    if direction == :up
      @cursor = [((@cursor[0]-1) % @size), @cursor[1]]
    elsif direction == :down
      @cursor = [((@cursor[0]+1) % @size), @cursor[1]]
    elsif direction == :left
      @cursor = [(@cursor[0]), ((@cursor[1]-1) % @size)]
    elsif direction == :right
      @cursor = [(@cursor[0]), ((@cursor[1]+1) % @size)]
    end

    self
  end

  def redraw_board
    system "clear"
    display_board

    self
  end

  def display_board
    @grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        if @cursor[0] == i && @cursor[1] == j
          print "[".blue + "#{tile.symbol}" + "]".blue
        else
          print " #{tile.symbol} "
        end
      end
      puts
    end

    puts "wsad to move, q to quit and save"
    puts "r to reveal, f to flag/unflag"

    self
  end

  def reveal_bombs
    system "clear"

    @grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        if tile.is_bomb && !tile.flagged
          print " b ".red
        else
          print " #{tile.symbol} "
        end
      end
      puts
    end

    self
  end

  def save_as
    puts "Create a filename for your saved game."
    gets.chomp
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def pick_a_tile
    puts "Pick a tile to reveal or flag"
    gets.chomp.split('').map(&:to_i)
  end

  def over?
    everything_revealed = true
    validflags = true
    @grid.each do |row|
      row.each do |pos|
        return true if pos.symbol == 'b'.red
        everything_revealed = false unless pos.revealed || pos.flagged
        if pos.is_bomb
          unless pos.flagged
            validflags = false
          end
        end
      end
    end

    everything_revealed && validflags
  end

  def won?
    everything_revealed = true
    validflags = true
    @grid.each do |row|
      row.each do |pos|
        return false if pos.symbol == "b".red
        everything_revealed = false unless pos.revealed || pos.flagged
        if pos.is_bomb
          unless pos.flagged
            validflags = false
          end
        end
      end
    end

    everything_revealed && validflags
  end
end


class LeaderBoard

end


b = Board.new(10)
b.play











