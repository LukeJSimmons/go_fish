require_relative 'card'

BASE_DECK_SIZE = 52

class CardDeck
  attr_reader :cards

  def initialize
    @cards = build_cards
  end

  def draw_card
    cards.pop
  end

  def shuffle!
    cards.shuffle!
  end

  def ==(other_deck)
    cards == other_deck.cards
  end

  private

  def build_cards
    Card::SUITS.flat_map do |suit|
      Card::RANKS.map do |rank|
        Card.new(rank, suit)
      end
    end
  end
end