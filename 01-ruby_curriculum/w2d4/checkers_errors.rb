class InvalidMoveError < RuntimeError
  attr_reader :message

  def initialize
    @message = "invalid move."
  end
end

class ForceEndGame < StandardError
  attr_reader :message

  def initialize
    @message = "Quitting game..."
  end
end