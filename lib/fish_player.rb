class FishPlayer
  attr_reader :hand, :name, :books
  
  def initialize(name="Random Player")
    @name = name
    @hand = []
    @books = []
  end

  def add_card_to_hand(card, check_book=true)
    hand.unshift card
    check_for_book if check_book
  end

  def request_card
    hand.sample # Will eventually request input from the client
  end

  def get_matching_cards(card_request)
    matching_cards = hand.select { |card| card.rank == card_request.rank }
    matching_cards.each { |card| hand.delete(card) }
    matching_cards
  end

  def check_for_book
    book = has_book?
    book.each do |book_card|
      hand.delete(book_card)
    end
    books << book
  end

  def has_book?
    ranks = Card::RANKS.map do |rank|
      hand.select do |card|
        card.rank == rank
      end
    end
    ranks.select { |rank| rank.count == 4 }.flatten
  end
end