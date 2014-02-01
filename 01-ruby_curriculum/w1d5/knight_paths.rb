require './treenode.rb'

class KnightPathFinder
  def initialize(starting_point)
    @starting_node = TreeNode.new(starting_point, nil)
    @tree_map = [@starting_node]
  end

  def find_path(target)
    build_move_tree!
    target_node = @tree_map.select { |node| node.value == target }.first

    raise RuntimeError.new("impossible or invalid destination!") if target_node.nil?
    TreeNode.gen_path_to_root(target_node)
  end


  private

  def build_move_tree!
    visited = [@starting_node.value]

    @tree_map.each do |node|
      build_next_moves!(node, visited)
    end
    nil
  end

  def build_next_moves!(parent, visited)
    poss_moves = new_move_positions(parent.value)
    poss_moves.select! { |x, y| x >= 0 && x < 8 && y < 8 && y >= 0 }

    poss_moves.each do |position|
      unless visited.include?(position)
        node = TreeNode.new(position, parent)
        parent.add_child(node)
        @tree_map << node
        visited << position
      end
    end
    nil
  end

  def new_move_positions(current_position)
    x, y = current_position

    diffs = [[-1, -2], [-2, -1], [-2, 1], [-1, 2],
             [1, 2], [2, 1], [2, -1], [1, -2]]

    moves = []
    diffs.each do |move_x, move_y|
      moves << [x + move_x, y + move_y]
    end
    moves
  end
end

knight = KnightPathFinder.new([0,0])
p knight.find_path([0, 7])