require_relative 'card'

class CardDeck
  attr_reader :cards

  BASE_DECK_SIZE = 52

  def initialize
    @cards = build_cards
  end

  def draw_card
    cards.pop
  end

  def shuffle!
    cards.shuffle!
  end

  def ==(other)
    cards == other.cards
  end

  def empty?
    cards.empty?
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
