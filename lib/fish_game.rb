require_relative 'card_deck'
require_relative 'fish_player'

class FishGame
  attr_reader :deck, :players
  attr_accessor :current_player, :current_opponent

  BASE_HAND_SIZE = 7

  def initialize
    @deck = CardDeck.new
    @players = [FishPlayer.new("Player 1"), FishPlayer.new("Player 2")]
    @current_player = players[0]
    @current_opponent = players[1]
  end

  def start
    deck.shuffle!
    deal_base_hands
  end

  def play_round
    card_request = current_player.request_card
    matching_cards = card_request ? current_opponent.get_matching_cards(card_request) : []
    matching_cards.each { |card| current_player.add_cards_to_hand(card) }

    if matching_cards.empty?
      current_player.add_cards_to_hand(deck.draw_card)
      swap_turns
    end
  end

  def play_game
    until deck.cards.empty?
      play_round
    end
  end

  def determine_winner
    total_books = players.map { |player| player.books.length }
    players[total_books.find_index(total_books.max)]
  end

  def swap_turns
    self.current_player, self.current_opponent = current_opponent, current_player
  end

  private

  def deal_base_hands
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_cards_to_hand(deck.draw_card) }
    end
  end
end