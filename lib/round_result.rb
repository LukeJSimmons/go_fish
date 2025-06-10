class RoundResult
  attr_reader :current_player, :target_player, :cards, :fished

  def initialize
    @current_player = current_player
    @target_player = target_player
    @cards = cards
    @fished = fished
  end
end