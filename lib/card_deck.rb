require_relative 'card'

BASE_DECK_SIZE = 52

class CardDeck
  attr_reader :cards

  def initialize
    @cards = Array.new(BASE_DECK_SIZE, Card.new)
  end

  def draw_card
    cards.pop
  end
end