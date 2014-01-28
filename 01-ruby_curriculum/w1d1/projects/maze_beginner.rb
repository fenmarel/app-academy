class Maze

  def initialize
    @maze = read_maze
    @start = find_start    
    @current_x, @current_y = @start
    
    print_map  
  end

  def print_map
    @maze.each do |row|
      p row.join("")
    end
    puts
  end

  def mark_path
    @maze[@current_x][@current_y] = "x"
  end

  def current_tile
    @maze[@current_x][@current_y]
  end

  def solve
    until current_tile == "E"
      mark_path unless current_tile == "S"
      move
    end
    print_map
  end

  def move
    [move_up, move_right, move_down, move_left].each do |pos|
      unless blocked?(pos)
        @current_x, @current_y = pos
        return
      end
    end
  end

  def move_up
    [@current_x - 1, @current_y]
  end

  def move_down
    [@current_x + 1, @current_y]
  end

  def move_right
    [@current_x, @current_y + 1]
  end

  def move_left
    [@current_x, @current_y - 1]
  end

  def blocked?(pos)
    ask = @maze[pos[0]][pos[1]]
    ask == "*" || ask == "x" || ask == "S"
  end

  
  private

  def find_start
    @maze.each_with_index do |x, xdex|
        x.each_with_index do |y, ydex|
          return [xdex, ydex] if y == "S"
        end
      end
  end

  def read_maze
    maze_out = []
    File.open('maze1.txt').each_line do |line|
      maze_out << line.chomp.split('')
    end
    maze_out
  end
end


m = Maze.new
m.solve
