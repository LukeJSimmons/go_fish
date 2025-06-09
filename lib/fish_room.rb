class FishRoom
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def run_round
    display_hand
  end

  private

  def display_hand
    game.current_player.client.puts game.current_player.hand.map(&:rank).join(' ')
  end
end