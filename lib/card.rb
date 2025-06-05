class Card
  attr_reader :rank, :suit

  def initialize(rank='2', suit='C')
    @rank = rank
    @suit = suit
  end
end