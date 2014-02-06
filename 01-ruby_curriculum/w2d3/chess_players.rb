class Player
  attr_reader :color
  attr_accessor :name

  def initialize(color, board)
    @name = nil
    @color = color
    @board = board
  end

  def other_color(color)
    color == :white ? :black : :white
  end
end

class HumanPlayer < Player
  def play_turn(start_pos, end_pos)
    if start_pos[1].nil? || start_pos[0].nil? || start_pos.nil? ||
       end_pos[1].nil? || end_pos[0].nil? || end_pos.nil? ||
       !@board.get_pieces(@color).include?(@board[start_pos])

      raise InvalidMoveError
    end

    @board.move(start_pos, end_pos)

    self
  end
end

class ComputerPlayer < Player
  def generate_move
    final_scores = []
    our_pieces = @board.get_pieces(@color)
    score = @board.score(@color)

    our_pieces.shuffle.each do |piece|
      possible_moves = piece.valid_moves(@board)
      curr_distance = distance_from_enemy_king(piece.pos)

      possible_moves.each do |possible_finish|
        next_board = @board.dup
        next_board.move(piece.pos, possible_finish)
        next_score = next_board.score(@color)
        next_score += 1 if distance_from_enemy_king(possible_finish) < curr_distance

        if next_board.checkmate?(other_color(@color))
          return [piece.pos, possible_finish]
        end

        enemy_pieces = next_board.get_pieces(other_color(@color))

        enemy_pieces.each do |enemy_piece|
          enemy_moves = enemy_piece.valid_moves(next_board)
          enemy_moves.each do |enemy_move|
            enemy_board = next_board.dup
            enemy_board.move(enemy_piece.pos, enemy_move)
            enemy_move_score = enemy_board.score(@color)

            if enemy_move_score < next_score
              final_score =  score - next_score
            else
              final_score = score - enemy_move_score
            end

            final_scores << [final_score, [piece.pos, possible_finish]]
          end
        end
      end
    end

    final_scores.reject! { |_, pos| pos.nil? }
    final_scores.sort_by { |score, _| score }.first[1]
  end

  def distance_from_enemy_king(pos)
    enemy_color = other_color(@color)
    king_pos = @board.find_king(enemy_color)

    a2 = (king_pos[0] - pos[0]) ** 2
    b2 = (king_pos[1] - pos[1]) ** 2

    (a2 + b2) ** (1.0/2)
  end

  def play_turn
    @board.move(*generate_move)
  end
end
