class Hand
  attr_reader :cards

  def initialize(deck)
    @deck = deck
    @cards = draw_hand
  end

  def exchange(cards)
    get_rid_of = []

    cards.each do |dex|
      get_rid_of << @cards[dex]
    end

    get_rid_of.each do |card|
      @cards.delete(card)
      @cards << @deck.draw
    end

    self
  end

  def card_values
    @cards.map(&:value)
  end


  def high_card
    @cards.sort_by { |card| card.value }.last.value
  end

  def pair?
    card_map = card_values
    pairs = card_map.select { |card| card_map.count(card) == 2 }.sort
    pairs.empty? ? false : pairs.last
  end

  def two_pair?
    card_map = card_values
    pairs = card_map.select { |card| card_map.count(card) == 2 }

    pairs.count == 4 ? pairs.sort.last : false
  end

  def three?
    card_map = card_values
    three_of = card_map.select { |card| card_map.count(card) == 3 }

    three_of.empty? ? false : three_of.last
  end

  def full_house?
    pair? && three? ? three? : false
  end

  def straight?
    card_map = card_values.sort

    card_map.each_with_index do |card, i|
      next if i + 1 == card_map.length

      return false unless (card + 1) == card_map[i + 1]
    end

    card_map.last
  end

  def flush?
    suit_map = @cards.map(&:suit)

    suit_map.uniq.length == 1 ? high_card : false
  end

  def straight_flush?
    straight? && flush? ? high_card : false
  end

  def four?
    card_map = card_values
    four_of = card_map.select { |card| card_map.count(card) == 4 }

    four_of.empty? ? false : four_of.last
  end

  def score_hand
    high_card_type = 0
    hand_types = [:straight_flush?, :four?, :full_house?, :flush?,
                  :straight?, :three?, :two_pair?, :pair?]

    hand_types.each_with_index do |type, i|
      return 8 - i if self.send(type)
    end

    high_card_type
  end

  private

  def draw_hand
    [].tap do |hand|
      5.times { hand << @deck.draw }
    end
  end
end



class Player
  attr_reader :money, :hand
  attr_accessor :name, :current_bet, :fold

  def initialize(deck)
    @name = nil
    @deck = deck
    @hand = Hand.new(@deck)
    @money = 100
    @current_bet = nil
    @fold = false
  end

  def bet(amount)
    @money -= amount
  end

  def win_pot(amount)
    @money += amount
  end

  def evaluate_hand
    @hand.score_hand
  end

  def show_hand
    hand = ""
    self.hand.cards.each do |card|
      hand += "| #{card.value} #{card.suit} "
    end

    puts hand + '|'
  end
end