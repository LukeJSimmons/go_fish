class FishPlayer
  attr_reader :hand, :name, :books, :client

  def initialize(name = 'Random Player', client=nil)
    @name = name
    @hand = []
    @books = []
    @client = client
  end

  def add_cards_to_hand(cards, check_book = true)
    hand.unshift(*Array(cards))
    check_for_book if check_book
    cards
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
    book = get_book
    book.each do |book_card|
      hand.delete(book_card)
    end
    books << book if book_only_contains_cards?(book)
  end

  def get_book
    hand.group_by(&:rank).select { |rank, cards| cards.count == 4 }.first&.last || []
  end

  private

  def book_only_contains_cards?(book)
    book.all? { |card| card.respond_to? :rank } && !book.empty?
  end
end
