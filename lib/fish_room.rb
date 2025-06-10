class FishRoom
  attr_reader :game, :clients
  attr_accessor :target, :request, :current_player, :current_opponents

  def initialize(game, clients, target = nil, request = nil)
    @game = game
    @clients = clients
    @target = target
    @request = request
    @current_player = game.current_player
    @current_opponents = game.current_opponents
  end

  def run_round
    self.current_player = game.current_player
    self.current_opponents = game.current_opponents

    display_hand
    target = get_target
    request = get_request
    results = game.play_round(target, request)

    display_results(results)
  end

  def run_game
    run_round until game.deck.empty? || game.players.any? { |player| player.hand.empty? }
    message_all_clients game.determine_winner.name + ' Wins'
    game.determine_winner
  end

  private

  def display_hand
    current_opponents.each do |opponent|
      clients[opponent].puts "Waiting for #{current_player.name} to finish their turn..."
    end
    message_current_player "#{game.current_player.name}, your hand is: " + game.current_player.hand.map(&:rank).sort.join(' ')
  end

  def get_target # OVER 7-LINES : 10-LINES
    message_current_player "Who would you like to target? Your opponents are, #{current_opponents.map(&:name).join(' ')}:"

    target = game.current_opponents.first if target

    until target
      input = target || get_current_player_input
      target = game.players.find { |player| player.name == input }
    end

    message_current_player target.name
    target
  end

  def get_request # OVER 7-LINES : 10-LINES
    message_current_player 'Please input your request: '

    request = game.current_player.hand.sample if request

    until request
      input = request || get_current_player_input until input
      request = game.current_player.hand.find { |card| card.rank == input }
    end

    message_current_player request.rank
    request
  end

  def display_results(results)
    if results.is_a? Array
      message_all_clients "#{current_player.name} took #{if results.count == 1
                                                           'a'
                                                         end} #{results.count} #{results.first.rank}#{unless results.count == 1
                                                                                                        's'
                                                                                                      end}"
    else
      message_all_clients "Go fish, #{current_player.name} took nothing"
      message_current_player "You took a #{results.rank} from the deck"
    end
  end

  def message_current_player(message)
    clients[current_player].puts message
  end

  def message_all_clients(message)
    clients.each do |_player, client|
      client.puts message
    end
  end

  def get_current_player_input
    sleep 0.1
    begin
      clients[current_player].read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end
