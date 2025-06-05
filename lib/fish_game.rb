require_relative 'card_deck'

class FishGame
  attr_reader :deck

  def initialize
    @deck = CardDeck.new
  end
end