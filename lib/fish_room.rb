class FishRoom
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def run_round
    display_hand
    target = get_target
    message_current_player "Your target is: " + target.name
    request = get_request
    message_current_player "Your request is: " + request.rank
  end

  private

  def display_hand
    message_current_player "Your hand is: " + game.current_player.hand.map(&:rank).join(' ')
  end

  def get_target
    message_current_player "Please input your target: "
    input = get_current_player_input
    game.players.find { |player| player.name == input }
  end

  def get_request
    message_current_player "Please input your request: "
    input = get_current_player_input
    game.current_player.hand.find { |card| card.rank == input }
  end

  def message_current_player(message)
    game.current_player.client.puts message
  end

  def get_current_player_input
    sleep 0.1
    begin
      game.current_player.client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end