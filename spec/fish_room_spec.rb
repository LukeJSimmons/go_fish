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
  let(:current_player) { room.game.current_player }
  describe '#initialize' do
    it 'has a game' do
      expect(room).to respond_to :game
    end
  end

  describe '#run_round' do
  let(:game) { @server.create_game_if_possible }

    context 'when Player 1 is current player' do
      let(:room) {
        FishRoom.new(
          game,
          game.current_opponents.first.name,
          game.current_player.hand.sample.rank)
      }

      it 'displays current player hand to their client' do
        hand = current_player.hand.map(&:rank).join(' ')
        room.run_round
        expect(client1.capture_output).to include current_player.name + ", your hand is: " + hand
      end

      it 'asks the player for a target' do
        room.run_round
        expect(client1.capture_output).to match (/target/i)
      end

      it 'displays the target back to the player' do
        room.run_round
        expect(client1.capture_output).to include "Player 2"
      end

      it 'asks the player for a request' do
        room.run_round
        expect(client1.capture_output).to match (/request/i)
      end

      it 'displays the request back to the player' do
        room.run_round
        expect(client1.capture_output).to include "#{room.request}"
      end

      it 'displays results' do
        room.run_round
        expect(client1.capture_output).to include "Player 1 took"
      end
    end

    context 'when Player 2 is current player' do
      let(:room) {
        FishRoom.new(
          game,
          game.current_opponents.first.name,
          game.current_player.hand.sample.rank
          )
        }
      
      before do
        room.game.round = 1
        room.target = game.current_opponents.first.name
        room.request = room.game.current_player.hand.sample.rank
      end

      it 'displays current player hand to their client' do
        hand = current_player.hand.map(&:rank).join(' ')
        room.run_round
        expect(client2.capture_output).to include current_player.name + ", your hand is: " + hand
      end

      it 'asks the player for a target' do
        room.run_round
        expect(client2.capture_output).to match (/target/i)
      end

      it 'displays the target back to the player' do
        room.run_round
        expect(client2.capture_output).to include "Player 1"
      end

      it 'asks the player for a request' do
        room.run_round
        expect(client2.capture_output).to match (/request/i)
      end

      it 'displays the request back to the player' do
        room.run_round
        expect(client2.capture_output).to include "#{room.request}"
      end

      it 'displays results' do
        room.run_round
        expect(client2.capture_output).to match (/took/i)
      end
    end
  end

  describe '#run_game' do
    let(:game) { @server.create_game_if_possible }

    let(:room) {
      FishRoom.new(
        game,
        game.current_opponents.first.name,
        game.current_player.hand.sample.rank
        )
      }

    it 'displays winner' do
      expect(room.run_game).to respond_to :hand
    end
  end
end