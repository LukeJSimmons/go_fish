class RoundResult
  attr_reader :current_player, :target_player, :cards, :fished, :requested_card

  def initialize(current_player, target_player, cards, fished, requested_card)
    @current_player = current_player
    @target_player = target_player
    @cards = cards
    @fished = fished
    @requested_card = requested_card
  end
end