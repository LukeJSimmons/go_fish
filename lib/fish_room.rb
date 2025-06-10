class FishRoom
  attr_reader :game, :clients
  attr_accessor :target, :rank, :current_player, :current_opponents, :request_target_message, :request_rank_message

  def initialize(game, clients)
    @game = game
    @clients = clients
    @request_target_message = true
    @target = nil
    @request_rank_message = true
    @rank = nil
  end

  def run_round
    display_hand
    self.target = get_target if !target
    self.rank = get_rank if !rank && target
    results = game.play_round if target && rank

    display_results(results) if results
  end

  def run_game
    run_round until game.deck.empty? || game.players.any? { |player| player.hand.empty? }
    message_all_clients game.determine_winner.name + ' Wins'
    game.determine_winner
  end

  def get_target
    message_current_player "Who would you like to target? Your opponents are, #{game.current_opponents.map(&:name).join(' ')}:" if request_target_message
    self.request_target_message = false

    target_name_input = get_current_player_input
    target_player = game.players.find { |player| player.name == target_name_input && player != current_player }

    message_current_player target_name_input if target_name_input
    target_player
  end

  def get_rank
    message_current_player "Please input your rank: " if request_rank_message
    self.request_rank_message = false

    rank_input = get_current_player_input
    rank_card = game.current_player.hand.find { |card| card.rank == rank_input }

    message_current_player rank_input if rank_input
    rank_card
  end

  private

  def display_hand
    game.current_opponents.each do |opponent|
      clients[opponent].puts "Waiting for #{game.current_player.name} to finish their turn..."
    end
    message_current_player "#{game.current_player.name}, your hand is: " + game.current_player.hand.map(&:rank).sort.join(' ')
  end

  def message_current_player(message)
    clients[game.current_player].puts message
  end

  def message_all_clients(message)
    clients.each do |_player, client|
      client.puts message
    end
  end

  def display_results(results)
    if results.is_a? Array
      message_all_clients "#{game.current_player.name} took #{if results.count == 1
                                                           'a'
                                                         end} #{results.count} #{results.first.rank}#{unless results.count == 1
                                                                                                        's'
                                                                                                      end}"
    else
      message_all_clients "Go fish, #{game.current_player.name} took nothing"
      message_current_player "You took a #{results.rank} from the deck"
    end
  end

  def get_current_player_input
    sleep 0.1
    begin
      clients[game.current_player].read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
end
