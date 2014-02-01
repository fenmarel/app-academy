require './ttt.rb'
# ttt is the stock tictactoe solution


class TicTacToeNode
  attr_reader :board, :previous_move

  def initialize(board, next_player, previous_move=nil)
    @board = board
    @next_player = next_player
    @previous_move = previous_move
  end

  def losing_node?(player)
    child_nodes = self.children

    if @board.over?
      @board.winner == swap_player(player)
    elsif player == @next_player
      child_nodes.all? { |node| node.losing_node?(player) }
    else
      child_nodes.any? { |node| node.losing_node?(player) }
    end
  end

  def winning_node?(player)
    child_nodes = self.children

    if @board.over?
      @board.winner == player
    elsif player == @next_player
      child_nodes.any? { |node| node.winning_node?(player) }
    else
      child_nodes.all? { |node| node.winning_node?(player) }
    end
  end

  def children
    child_nodes = []

    @board.rows.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        board_copy = @board.dup
        current_pos = [row_i, col_i]

        if board_copy.empty?(current_pos)
          board_copy[current_pos] = @next_player
          new_node = TicTacToeNode.new(board_copy, swap_player(@next_player), current_pos)
          child_nodes << new_node
        end

      end
    end

    child_nodes
  end

  def swap_player(player)
    player == :x ? :o : :x
  end
end


class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    current_node = TicTacToeNode.new(game.board, mark)
    current_options = current_node.children.shuffle

    best_move = nil
    current_options.each do |move_option|
      best_move ||= move_option

      if move_option.board.winner == mark
        # take a winning move if possible
        return move_option.previous_move
      elsif best_move.losing_node?(mark) && !move_option.losing_node?(mark)
        # follow an impossible-lose path
        best_move = move_option
      elsif move_option.winning_node?(mark)
        # else follow a possible-win path
        best_move = move_option
      end
    end

    best_move.previous_move
  end
end




if __FILE__ == $PROGRAM_NAME
  hp = HumanPlayer.new("Jon")
  cp = SuperComputerPlayer.new

  TicTacToe.new(cp, hp).run
end