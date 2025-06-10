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

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe FishRoom do
  let(:client1) { MockFishSocketClient.new(@server.port_number) }
  let(:client2) { MockFishSocketClient.new(@server.port_number) }

  before(:each) do # OVER 7-LINES
    @clients = []
    @server = FishSocketServer.new
    @server.start
    sleep 0.1
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

  let(:game) { @server.create_game_if_possible }
  let(:clients) { { game.players.first => @server.clients.first, game.players[1] => @server.clients[1] } }
  let(:room) { FishRoom.new(game, clients) }
  let(:current_player) { game.current_player }
  
  describe '#initialize' do
    it 'has a game' do
      expect(room).to respond_to :game
    end

    it 'has a current_player' do
      expect(room).to respond_to :current_player
    end

    it 'has current_opponents' do
      expect(room).to respond_to :current_opponents
    end

    it 'has clients' do
      expect(room).to respond_to :clients
    end
  end

  describe '#run_round' do
    let(:game) { @server.create_game_if_possible }

    context 'when Player 1 is current player' do
      let(:room) do
        FishRoom.new(
          game,
          clients
        )
      end

      before do
        # client1.provide_input(game.current_opponents.first.name)
        # room.run_round
        # client1.provide_input(game.current_player.hand.sample.rank)
      end

      it 'displays waiting message to current opponents' do
        expect(client2.capture_output).to match(/waiting/i)
      end

      it 'displays current player hand sorted to their client' do
        room.run_round
        hand = current_player.hand.map(&:rank).sort.join(' ')
        expect(client1.capture_output).to include current_player.name + ', your hand is: ' + hand
      end

      it 'displays results to all players' do
        expect(client1.capture_output).to include 'Player 1 took'
        expect(client2.capture_output).to include 'Player 1 took'
      end

      it 'does not display drawn to all players' do
        room.run_round
        expect(client1.capture_output).to include 'You took'
        expect(client2.capture_output).to_not include 'You took'
      end
    end

    context 'when Player 2 is current player' do
      let(:room) do
        FishRoom.new(
          game,
          clients
        )
      end

      before do
        room.game.round = 1
      end

      it 'displays current player hand to their client' do
        hand = current_player.hand.map(&:rank).sort.join(' ')
        room.run_round
        expect(client2.capture_output).to include current_player.name + ', your hand is: ' + hand
      end

      it 'displays results' do
        room.run_round
        expect(client2.capture_output).to match(/took/i)
      end
    end
  end

  describe '#get_target' do
    context 'when Player 1 is current_player' do
      before do
        client1.provide_input('Player 2')
      end

      it 'asks the player for a target' do
        room.get_target
        expect(client1.capture_output).to match(/target/i)
      end

      it 'displays possible targets to player' do
        room.get_target
        expect(client1.capture_output).to include 'Your opponents are, ' + room.game.current_opponents.map(&:name).join(' ')
      end

      it 'displays the target back to the player' do
        room.get_target
        expect(client1.capture_output).to include 'Player 2'
      end
    end

    context 'when Player 2 is current_player' do
      before do
        room.game.round = 1
        client2.provide_input('Player 1')
      end

      it 'asks the player for a target' do
        room.get_target
        expect(client2.capture_output).to match(/target/i)
      end

      it 'displays possible targets to player' do
        room.get_target
        expect(client2.capture_output).to include 'Your opponents are, ' + room.game.current_opponents.map(&:name).join(' ')
      end

      it 'displays the target back to the player' do
        room.get_target
        expect(client2.capture_output).to include 'Player 1'
      end
    end
  end

  describe '#get_rank' do
    let(:rank) { room.game.current_player.hand.sample.rank }

    context 'when Player 1 is current_player' do
      before do
        client1.provide_input(rank)
      end

      it 'asks the player for a rank' do
        room.get_rank
        expect(client1.capture_output).to match(/rank/i)
      end

      it 'displays the rank back to the player' do
        room.get_rank
        expect(client1.capture_output).to include "#{rank}"
      end
    end

    context 'when Player 2 is current_player' do
      before do
        room.game.round = 1
        client2.provide_input(rank)
      end

      it 'asks the player for a rank' do
        room.get_rank
        expect(client2.capture_output).to match(/rank/i)
      end

      it 'displays the rank back to the player' do
        room.get_rank
        expect(client2.capture_output).to include "#{rank}"
      end
    end
  end

  describe '#run_game' do
    let(:game) { @server.create_game_if_possible }

    let(:room) do
      FishRoom.new(
        game,
        clients
      )
    end

    xit 'displays winner' do
      expect(room.run_game).to respond_to :hand
    end
  end
end
