class Card
  attr_reader :rank, :suit, :value

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %w[H D C S]

  def initialize(rank = '2', suit = 'C')
    raise_error StandardError unless RANKS.include?(rank)
    raise_error StandardError unless SUITS.include?(suit)

    @rank = rank
    @suit = suit
    @value = RANKS.find_index(rank)
  end

  def ==(other)
    rank == other.rank &&
      suit == other.suit
  end
end
