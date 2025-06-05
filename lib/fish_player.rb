class FishPlayer
  attr_reader :hand, :name, :books
  
  def initialize(name="Random Player")
    @name = name
    @hand = []
    @books = []
  end

  def add_card_to_hand(card)
    hand.unshift card
  end

  def request_card
    hand.sample # Will eventually request input from the client
  end

  def get_matching_cards(card_request)
    matching_cards = hand.select { |card| card.rank == card_request.rank }
    matching_cards.each { |card| hand.delete(card) }
    matching_cards
  end

  def has_book?
    matching_cards = []
    hand.each do |card|
      matching_cards = hand.select do |other_card|
        card.rank == other_card.rank && card.suit != other_card.suit
      matching_cards
      end
    end
    matching_cards if matching_cards.count == 4
  end
end