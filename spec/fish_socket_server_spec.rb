require 'socket'
require 'fish_socket_server'

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

describe FishSocketServer do
  before(:each) do
    @clients = []
    @server = FishSocketServer.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect {MockFishSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  describe '#accept_new_client' do
    let(:client1) { MockFishSocketClient.new(@server.port_number) }

    before do
      @clients.push(client1)
    end

    it 'asks for client player name' do
      client1.provide_input("jim")
      @server.accept_new_client
      expect(client1.capture_output).to match (/name/i)
    end

    it 'sends input name back to the client' do
      client1.provide_input("jim")
      @server.accept_new_client
      expect(client1.capture_output).to match (/jim/i)
    end

    it 'sends a welcome message to client' do
      @server.accept_new_client('Player 1')
      expect(client1.capture_output).to match (/welcome/i)
    end
  end

  describe '#create_game_if_possible' do
    context 'when there is only one player' do
      let(:client1) { MockFishSocketClient.new(@server.port_number) }

      before do
        @clients.push(client1)
        @server.accept_new_client('Player 1')
      end

      it 'returns nil' do
        expect(@server.create_game_if_possible).to eq nil
      end
    end

    context 'when there are two players' do
      let(:client1) { MockFishSocketClient.new(@server.port_number) }
      let(:client2) { MockFishSocketClient.new(@server.port_number) }

      before do
        @clients.push(client1)
        @server.accept_new_client('Player 1')
        @clients.push(client2)
        @server.accept_new_client('Player 2')
      end

      it 'adds a FishGame with players to games' do
        @server.create_game_if_possible
        expect(@server.games.map(&:players)).to include(@server.players)
      end

      it 'sends a ready message to each client' do
        @server.create_game_if_possible
        expect(client1.capture_output).to match (/ready/i)
        expect(client2.capture_output).to match (/ready/i)
      end
    end

  end
  context 'when there are two players' do
      let(:client1) { MockFishSocketClient.new(@server.port_number) }
      let(:client2) { MockFishSocketClient.new(@server.port_number) }

      before do
        @clients.push(client1)
        @server.accept_new_client('Player 1')
        @clients.push(client2)
        @server.accept_new_client('Player 2')
      end
    
    describe '#create_room' do
      it 'adds a room to rooms array' do
        expect {
          @server.create_room(@server.create_game_if_possible)
        }.to change(@server.rooms, :count).by 1
      end

      it 'returns a FishRoom' do
        expect(@server.create_room(@server.create_game_if_possible)).to respond_to :game
      end
    end
  end
end