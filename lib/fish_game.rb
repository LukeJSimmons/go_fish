require_relative 'card_deck'

class FishGame
  attr_reader :deck, :players

  def initialize
    @deck = CardDeck.new
    @players = Array.new(2, FishPlayer.new)
  end
end