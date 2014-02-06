class CheckersPiece
  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board

    #  Change later to account for color
    @slide_move_diffs = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    @jump_move_diffs = [[2, 2], [2, -2], [-2, 2], [-2, -2]]
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

  def avilable_jumps
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
      !@board[between].color == @color
    end
  end

  def space_between(start, finish)
    startx, starty = start
    finishx, finishy = finish

    [(startx + finishx) / 2, (starty + finishy) / 2]
  end
end