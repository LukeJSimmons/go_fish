class FishPlayer
  attr_reader :hand, :name
  
  def initialize(name="Random Player")
    @hand = []
    @name = name
  end

  def add_card_to_hand(card)
    hand.unshift card
  end
end