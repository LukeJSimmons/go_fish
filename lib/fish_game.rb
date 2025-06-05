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

  def play_round
    card_request = current_player.request_card
    matching_cards = current_opponent.get_matching_cards(card_request)
    matching_cards.each { |card| current_player.add_card_to_hand(card) }
  end

  def current_player
    players[0]
  end
  
  def current_opponent
    players[1]
  end

  private

  def deal_base_hands
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_card_to_hand(deck.draw_card) }
    end
  end
end