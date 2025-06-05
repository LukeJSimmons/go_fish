require_relative 'card_deck'
require_relative 'fish_player'

class FishGame
  attr_reader :deck, :players

  BASE_HAND_SIZE = 7

  def initialize
    @deck = CardDeck.new
    @players = [FishPlayer.new("Player 1"), FishPlayer.new("Player 2")]
  end

  def start
    deck.shuffle!
    deal_base_hands
  end

  private

  def deal_base_hands
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_card_to_hand(deck.draw_card) }
    end
  end
end