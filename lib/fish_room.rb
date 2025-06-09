class FishRoom
  attr_reader :game
  attr_accessor :target, :request

  def initialize(game, target=nil, request=nil)
    @game = game
    @target = target
    @request = request
  end

  def run_round
    display_hand
    target = get_target
    request = get_request
    results = game.play_round(target, request)

    display_results(results)
  end

  def run_game
    run_round until game.deck.empty? || game.players.any? { |player| player.hand.empty? }
    message_all_clients game.determine_winner.name + " Wins"
    game.determine_winner
  end

  private

  def display_hand
    message_current_player "#{game.current_player.name}, your hand is: " + game.current_player.hand.map(&:rank).join(' ')
  end

  def get_target
    message_current_player "Please input your target: "
    if target
      target = game.current_opponents.first.name
    end
    input = target || get_current_player_input
    target = game.players.find { |player| player.name == input }

    get_target unless target

    message_current_player target.name
    target
  end

  def get_request
    message_current_player "Please input your request: "
    if request
      request = game.current_player.hand.sample.rank
    end
    input = request || get_current_player_input
    request = game.current_player.hand.find { |card| card.rank == input }
    
    get_request unless request

    message_current_player request.rank
    request
  end

  def display_results(results)
    if results.is_a? Array
      message_all_clients "You took #{'a' if results.count == 1} #{results.count} #{results.first.rank}#{'s' unless results.count == 1}"
    else
      message_all_clients "Go fish: You took a #{results.rank} from the deck"
    end
  end

  def message_current_player(message)
    game.current_player.client.puts message
  end

  def message_all_clients(message)
    game.players.map(&:client).each do |client|
      client.puts message
    end
  end

  def get_current_player_input
    sleep 0.1
    begin
      game.current_player.client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end