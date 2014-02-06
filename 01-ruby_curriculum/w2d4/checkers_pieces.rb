class CheckersPiece
  attr_reader :color
  attr_accessor :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @king = false

    #TODO: Change to account for color
    @slide_move_diffs = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    @jump_move_diffs = [[2, 2], [2, -2], [-2, 2], [-2, -2]]
  end

  def valid_sequence?(moves)
    possible_steps = moves.drop(1)
    start = @pos.dup
    current_board = @board.dup

    until possible_steps.empty?
      next_step = possible_steps.shift

      #TODO: prevent multiple slides

      if valid_step?(start, next_step, current_board)
        current_board.move_step!(start, next_step)
      else
        return false
      end

      start = next_step
    end

    true
  end

  def valid_step?(start, finish, board)
    return false if board[start].nil?
    all_moves = board[start].available_slides + board[start].available_jumps
    all_moves.include?(finish)
  end

  def available_slides
    slides = []
    posx, posy = @pos

    @slide_move_diffs.each do |dx, dy|
      slides << [posx + dx, posy + dy]
    end

    slides.select! { |x, y| x.between?(0, 7) && y.between?(0, 7) }
    slides.select { |pos| @board[pos].nil? }
  end

  def available_jumps
    jumps = []
    posx, posy = @pos

    @jump_move_diffs.each do |dx, dy|
      jumps << [posx + dx, posy + dy]
    end

    jumps.select! { |x, y| x.between?(0, 7) && y.between?(0, 7) }
    jumps.select do |possible|
      between = space_between(@pos, possible)

      @board[possible].nil? &&
      !@board[between].nil? &&
      @board[between].color != @color
    end
  end

  def space_between(start, finish)
    startx, starty = start
    finishx, finishy = finish

    [(startx + finishx) / 2, (starty + finishy) / 2]
  end
end