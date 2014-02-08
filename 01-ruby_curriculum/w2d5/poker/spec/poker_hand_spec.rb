require 'rspec'
require 'poker_hand'


describe Hand do
  subject(:hand) { Hand.new(Deck.new) }

  let(:four) do
    [Card.new('2', :Hearts), Card.new('A', :Diamonds),
     Card.new('A', :Spades), Card.new('A', :Hearts), Card.new('A', :Clubs)]
  end

  let(:two_pair) do
  [Card.new('2', :Hearts), Card.new('2', :Diamonds),
   Card.new('7', :Spades), Card.new('A', :Hearts), Card.new('A', :Clubs)]
  end

  let(:full_house) do
  [Card.new('2', :Hearts), Card.new('2', :Diamonds),
   Card.new('A', :Spades), Card.new('A', :Hearts), Card.new('A', :Clubs)]
  end

  let(:royal_flush) do
  [Card.new('10', :Spades), Card.new('J', :Spades),
   Card.new('Q', :Spades), Card.new('K', :Spades), Card.new('A', :Spades)]
  end


  it "should contain cards" do
    expect(hand.cards.first).to be_a(Card)
  end

  it "should contain 5 cards" do
    expect(hand.cards.count).to eq(5)
  end

  it "should be able to exchange card" do
    original_hand = hand.cards.dup
    hand.exchange(hand.cards.first)

    expect(hand.cards).to_not eq(original_hand)
  end


  context "determine correct hand types with two pair" do

    before(:each) { hand.instance_variable_set(:@cards, two_pair) }

    it "should determine high card" do
      expect(hand.high_card).to eq(13)
    end

    it "should determine a pair" do
      expect(hand.pair?).to be_true
    end

    it "should deteremine two pair" do
      expect(hand.two_pair?).to be_true
    end
  end

  context "determine correct hand types with full house" do

    before(:each) { hand.instance_variable_set(:@cards, full_house) }

    it "should not be two pair" do
      expect(hand.two_pair?).to be_false
    end

    it "should determine three of a kind" do
      expect(hand.three?).to be_true
    end

    it "should determine a full house" do
      expect(hand.full_house?).to be_true
    end
  end

  context "determine correct hand types with four of a kind" do

    before(:each) { hand.instance_variable_set(:@cards, four) }

    it "three should be false when four of a kind" do
      expect(hand.three?).to be_false
    end

    it "should determine four of a kind" do
      expect(hand.four?).to be_true
    end

    it "should not be two pair" do
      expect(hand.two_pair?).to be_false
    end
  end

  context "determine correct hand types with royal flush" do

    before(:each) { hand.instance_variable_set(:@cards, royal_flush) }

    it "pair should be false when no pair" do
      expect(hand.pair?).to be_false
    end

    it "should determine straight" do
      expect(hand.straight?).to be_true
    end

    it "should determine flush" do
      expect(hand.flush?).to be_true
    end

    it "should determine straight flush" do
      expect(hand.straight_flush?).to be_true
    end
  end
end



describe Player do

  subject(:player) { Player.new(Deck.new) }

  it "should decrease player money after bet" do
    expect{ player.bet(50) }.to change{ player.money }.by(-50)
  end

  it "should increase player money after winning" do
    expect{ player.win_pot(50) }.to change{ player.money }.by(50)
  end
end