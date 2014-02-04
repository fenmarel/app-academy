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
  def initialize(size)
    @size = size
    @grid = Array.new(@size) { Array.new(@size)}
    @cursor = [0,0]
    @leaderboard = load_leaderboard
    @timer = nil
    @score = nil
  end

  def play
    puts "Press enter for New Game or Type L for Load game"
    if gets.chomp == "L"
      load_game
    else
      set_board
    end

    @timer = Time.now
    until over?
      navigate_and_select
    end
    @score = Time.now - @timer

    display_outcome
  end


  private

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

  def display_high_scores
    puts "\nCurrent high scores for game size #{@size}:"
    @leaderboard.scores_hash[@size].each do |name, score|
      puts "#{name}\t\t#{score}"
    end

    self
  end

  def display_outcome
    if won?
      redraw_board
      puts "You found all the bombs and won!"
      if @leaderboard.high_score?(@size, @score)
        puts "High Score! Please enter your name!"
        @leaderboard.add_score(@size, gets.chomp, @score)
      end
    else
      reveal_bombs
      puts "You lose, try again."
    end

    display_high_scores
  end

  def save_as
    puts "Create a filename for your saved game."
    gets.chomp
  end

  def load_game
    puts "What was the name of your saved game?"
    filename = gets.chomp
    @grid = YAML::load(File.read(filename).chomp)
    @size = @grid.length
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

  def set_board
    @grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        @grid[i][j] = Tile.new(rand() < 0.15, [i,j])
      end
    end

    self
  end

  def load_leaderboard
    if File.exist?('leaderboard')
      YAML::load(File.read('leaderboard').chomp)
    else
      LeaderBoard.new
    end
  end
end


class LeaderBoard
  attr_reader :scores_hash

  def initialize
    @scores_hash = Hash.new { |h, k| h[k] = [] }
  end

  def high_score?(size, time)
    return true if @scores_hash[size].length < 10

    @scores_hash[size].any? { |score| score > time }
  end

  def add_score(size, name, time)
    if @scores_hash[size].nil?
      @scores_hash[size] = [[name, time]]
    else
      @scores_hash[size] << [name, time]
      @scores_hash[size] = @scores_hash[size].sort_by { |p, t| t }.take(10)
    end

    File.open('leaderboard', 'w') { |f| f.puts self.to_yaml }

    self
  end
end


b = Board.new(5)
b.play











