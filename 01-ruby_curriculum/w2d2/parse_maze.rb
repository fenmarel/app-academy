# crude maze parser for mazes from
# http://www.delorie.com/game-room/mazes/genmaze.cgi
# to replace walls with * char
# S - Start and E End must be added manually before or after parsing


class MazeParser
  def initialize(maze_path)
    load_maze(maze_path)
  end

  def load_maze(maze_path)
    rows = File.read(maze_path).split("\n")

    File.open('generated_maze.txt', 'w') do |f|
      rows.each do |row|
        f.puts row.gsub(/[|+\-]/, '*')
      end
    end
  end
end

m = MazeParser.new('unformatted_maze4.txt')