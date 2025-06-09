require 'fish_game'
require 'fish_player'

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
  
  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end

  def accept_new_client(player_name="Random Player")
    client = @server.accept_nonblock
    clients << client
    players << FishPlayer.new(player_name,client)
    client.puts "Welcome to Go Fish!"
  end

  def create_game_if_possible
    return unless players.count == 2
    message_all_clients("All players have joined. We're ready to play!")
    game = FishGame.new(players)
    games << game
    game.start
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
end