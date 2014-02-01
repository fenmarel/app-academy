class TreeNode
  attr_accessor :parent, :children, :value

  def initialize(value, parent, children=[])
    @value = value
    @parent = parent
    @children = children
  end

  def self.gen_path_to_root(node)
    return node.value if node.parent.nil?

    path = [node.value]
    until node.parent.nil?
      path << node.parent.value
      node = node.parent
    end

    path.reverse
  end

  def remove_child(child_node)
    @children.each_with_index do |child|
      if child.value == child_node.value
        child.parent = nil
        @children.delete(child)
      end
    end
    nil
  end

  def add_child(child_node)
    unless child_node.parent.nil?
      child_node.parent.remove_child(child_node)
    end

    child_node.parent = self
    @children << child_node
  end

  def dfs(value)
    return self if @value == value
    check_list = @children.dup

    until check_list.nil?
      current = check_list.pop
      return gen_path_to_root if current.value == value
      check_list += current.children
    end
    false
  end

  def dfs_rec(value)
    return true if value == @value

    found = false
    @children.each do |child|
      check = child.dfs_rec(value)
      found ||= check
      return TreeNode.gen_path_to_root(child) if child.value == value
    end
    found
  end

  def bfs(value)
    return self if @value == value
    check_list = @children.dup

    until check_list.nil?
      current = check_list.shift
      return gen_path_to_root if current.value == value
      check_list += current.children
    end
    false
  end
end


# one = TreeNode.new(1, nil)
# two = TreeNode.new(2, one)
# three = TreeNode.new(3, one)
# four = TreeNode.new(4, three)
# five = TreeNode.new(5, four)
# six = TreeNode.new(6, five)
#
# one.add_child(two)
# one.add_child(three)
# three.add_child(four)
# four.add_child(five)
# five.add_child(six)
#
#
# p one.dfs_rec(6)

