class FishPlayer
  attr_reader :hand, :name
  
  def initialize(name="Random Player")
    @name = name
    @hand = []
  end

  def add_card_to_hand(card)
    hand.unshift card
  end

  def request_card
    hand.sample # Will eventually request input from the client
  end

  def has_card?(card)
    hand.include?(card)
  end
end