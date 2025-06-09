require 'fish_room'
require 'fish_game'
require 'fish_socket_server'
require 'socket'

class MockFishSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe FishRoom do
  let(:client1) { MockFishSocketClient.new(@server.port_number) }
  let(:client2) { MockFishSocketClient.new(@server.port_number) }

  before(:each) do
    @clients = []
    @server = FishSocketServer.new
    @server.start
    sleep 0.2
    @clients.push(client1)
    @server.accept_new_client('Player 1')
    @clients.push(client2)
    @server.accept_new_client('Player 2')
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  let(:room) { FishRoom.new(@server.create_game_if_possible) }
  describe '#initialize' do
    it 'has a game' do
      expect(room).to respond_to :game
    end
  end

  describe '#run_round' do
    it 'displays current player hand to their client' do
      room.run_round
      expect(client1.capture_output).to include "Your hand is: " + room.game.current_player.hand.map(&:rank).join(' ')
    end

    it 'asks the player for a target' do
      room.run_round
      expect(client1.capture_output).to match (/target/i)
    end

    it 'displays the target back to the player' do
      client1.provide_input "Player 2"
      room.run_round
      expect(client1.capture_output).to include "Player 2"
    end
  end
end