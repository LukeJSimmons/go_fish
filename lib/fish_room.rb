class FishRoom
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def run_round(default_target=nil,default_request=nil)
    display_hand
    target = get_target(default_target)
    request = get_request(default_request)
    results = game.play_round(target, request)
    display_results(results)
  end

  private

  def display_hand
    message_current_player "#{game.current_player.name}, your hand is: " + game.current_player.hand.map(&:rank).join(' ')
  end

  def get_target(default_target=nil)
    message_current_player "Please input your target: "
    input = default_target || get_current_player_input
    target = game.players.find { |player| player.name == input }

    get_target(default_target) unless target

    message_current_player "Your target is: " + target.name
    target
  end

  def get_request(default_request=nil)
    message_current_player "Please input your request: "
    input = default_request || get_current_player_input
    request = game.current_player.hand.find { |card| card.rank == input }
    
    get_request(default_request) unless request

    message_current_player "Your request is: " + request.rank
    request
  end

  def display_results(results)
    if results.is_a? Array
      message_all_clients "You took #{'a' if results.count == 1} #{results.count} #{results.first.rank}#{'s' unless results.count == 1}"
    else
      message_all_clients "Go fish: You took a #{results} from the deck"
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