require 'colorize'

class Maze
  def initialize(maze_path)
    @maze = load_maze(maze_path)
  end

  def display_maze
    @maze.each do |row|
      row.each do |position|
        position.nil? ? print(" ") : print(position)
      end
      puts
    end

    self
  end

  def find(symbol)
    @maze.each_with_index do |row, i|
      row.each_with_index do |position, j|
        return [i, j] if position == symbol
      end
    end

    nil
  end

  def [](position)
    @maze[position[0]][position[1]]
  end

  def mark(pos, mark)
    self[pos] = mark
  end


  private

  def load_maze(path)
    maze = []
    maze_rows = File.read(path).split("\n")

    maze_rows.each do |row|
      maze << row.split('')
    end

    maze
  end

  def []=(position, mark)
    @maze[position[0]][position[1]] = mark
  end
end


class MazeCrawler
  def initialize(maze)
    @maze = maze
    @start = @maze.find("S")
    @finish = @maze.find("E")
    @tree = Hash.new
    @to_explore = [@start]
    @explored = []
  end

  def animate_path
    path = solve_maze.drop(1)

    until path.empty?
      system 'clear'
      @maze.display_maze

      next_exploration = path.shift

      @maze.mark(next_exploration, 'x'.red)
      sleep(0.05)
    end
  end

  def solve_maze
    crawl_maze
    path = []

    next_path_back = @finish
    until path.first == @start
      path.unshift(next_path_back)
      next_path_back = @tree[next_path_back]
    end

    path
  end


  private

  def crawl_maze
    until @to_explore.empty? || @tree.has_key?(@finish)
      next_exploration = @to_explore.shift

      surrounding = surrounding_positions(next_exploration)
      surrounding.each do |pos|
        @tree[pos] ||= next_exploration
      end

      @explored += surrounding
      @to_explore += surrounding
    end

    self
  end

  def surrounding_positions(position)
    surrounding = []

    posx, posy = position
    diffs = [[-1, -1], [-1, 0], [-1, 1],
             [0, -1],           [0, 1],
             [1, -1],  [1, 0],  [1, 1]]

    diffs.each do |dx, dy|
      surrounding << [posx + dx, posy + dy]
    end

    surrounding.select! do |pos|
      @maze[pos] != '*' && !@explored.include?(pos)
    end

    surrounding
  end
end

m = Maze.new('maze3.txt')

c = MazeCrawler.new(m)

# t = Time.now
# c.solve_maze
# p Time.now - t

# 1.5sec for 20x20 with a medium path (maze3)
# 10.0sec for 30x30 with a long path (maze4)
# would need to rework algorithm for anything much bigger

c.animate_path








