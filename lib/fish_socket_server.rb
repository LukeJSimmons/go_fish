require 'socket'
require_relative 'fish_game'
require_relative 'fish_player'
require_relative 'fish_room'

class FishSocketServer
  def port_number
    3000
  end

  def clients
    @clients ||= []
  end

  def players
    @players ||= []
  end

  def games
    @games ||= []
  end

  def rooms
    @rooms ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end

  def accept_new_client(player_name = nil)
    client = @server.accept_nonblock
    player_name ||= get_name_input(client)
    clients << client
    players << FishPlayer.new(player_name)
    client.puts "Welcome to Go Fish #{player_name}!"
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_game_if_possible
    return unless players.count == 2

    message_all_clients("All players have joined. We're ready to play!")
    game = FishGame.new(players)
    games << game
    game.start
    game
  end

  def create_room(game)
    room = FishRoom.new(
      game,
      {
        players.first => clients.first,
        players[1] => clients[1]
      }
    )
    rooms << room
    room
  end

  private

  def message_all_clients(message)
    clients.each { |client| client.puts message }
  end

  def get_client_input(client)
    sleep(0.1)
    begin
      client.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end

  def get_name_input(client)
    client.puts 'Please input your name:'
    name = nil
    name = get_client_input(client) until name
    name
  end
end
