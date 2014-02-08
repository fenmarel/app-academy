class Card
  attr_reader :rank, :suit, :value

  VALUES = %W(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = VALUES.index(rank) + 1
  end
end


class Deck
  attr_reader :cards

  def initialize
    @cards = populate_cards
  end

  def populate_cards
    deck = []
    suits = [:Spades, :Hearts, :Diamonds, :Clubs]
    ranks = %W(2 3 4 5 6 7 8 9 10 J Q K A)

    suits.each do |suit|
      ranks.each do |rank|
        deck << Card.new(rank, suit)
      end
    end

    deck.shuffle
  end

  def draw
    @cards.pop
  end

  def shuffle!
    @cards.shuffle!
  end
end


