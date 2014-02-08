require 'rspec'
require 'poker_cards'


describe Card do

  subject(:card) { Card.new("A", :Spades) }

  it "should have a value" do
    expect(card.value).to eq(13)
  end

  it "should have a suit" do
    expect(card.suit).to eq(:Spades)
  end
end

describe Deck do

  subject(:deck) { Deck.new }

  it "should have 52 cards" do
    expect(deck.cards.count).to eq(52)
  end

  it "should contain 13 of each suit" do
    hearts = deck.cards.select { |card| card.suit == :Hearts }
    expect(hearts.count).to eq(13)

    clubs = deck.cards.select { |card| card.suit == :Clubs }
    expect(clubs.count).to eq(13)

    spades = deck.cards.select { |card| card.suit == :Spades }
    expect(spades.count).to eq(13)

    diamonds = deck.cards.select { |card| card.suit == :Diamonds }
    expect(diamonds.count).to eq(13)
  end

  it "should have 1 less card after a card is drawn" do
    expect { deck.draw }.to change { deck.cards.count }.by(-1)
  end

  it "should shuffle the deck on shuffle call" do
    cards = deck.cards.dup
    deck.shuffle!

    expect(deck.cards).to_not eq(cards)
  end
end