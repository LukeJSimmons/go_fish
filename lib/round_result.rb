class RoundResult
  attr_reader :current_player, :target_player, :cards, :fished, :requested_rank

  def initialize
    @current_player = current_player
    @target_player = target_player
    @cards = cards
    @fished = fished
    @requested_rank = requested_rank
  end
end