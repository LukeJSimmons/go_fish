require_relative 'card_deck'
require_relative 'fish_player'
require_relative 'round_result'

class FishGame
  attr_reader :deck, :players
  attr_accessor :round

  BASE_HAND_SIZE = 7

  def initialize(players = [FishPlayer.new('Player 1'), FishPlayer.new('Player 2')])
    @deck = CardDeck.new
    @players = players
    @round = 0
  end

  def start
    deck.shuffle!
    deal_base_hands
    self
  end

  def play_round(target, requested_card)
    matching_cards = requested_card ? target.get_matching_cards(requested_card) : []
    matching_cards.each { |card| current_player.add_cards_to_hand(card) }

    return matching_cards unless matching_cards.empty?

    go_fish(requested_card)
  end

  def determine_winner
    total_books = players.map { |player| player.books.length }

    if total_books.uniq.count != total_books.count
      highest_ranks = players.map { |player| player.books.map { |book| book.first.value } }
      return players[highest_ranks.find_index(highest_ranks.max)]
    end

    players[total_books.find_index(total_books.max)]
  end

  def current_player
    players[round % players.count]
  end

  def current_opponents
    players.select { |player| player != current_player }
  end

  private

  def deal_base_hands
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_cards_to_hand(deck.draw_card) }
    end
  end

  def go_fish(requested_card)
    drawn_card = current_player.add_cards_to_hand(deck.draw_card)
    return unless requested_card

    self.round += 1 unless drawn_card.rank == requested_card.rank
    drawn_card
  end
end
