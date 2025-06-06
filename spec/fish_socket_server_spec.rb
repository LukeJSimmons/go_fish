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
      @server.accept_new_client('Player 1')
    end

    it 'sends a welcome message to client' do
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

      it 'returns a FishGame with players' do
        expect(@server.create_game_if_possible.players).to eq @server.players
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
    describe '#run_game' do
      before do
        @server.create_game_if_possible
      end

      it 'displays current hand' do
        @server.run_game
        expect(client1.capture_output).to include @server.players[0].hand.join(' ')
        expect(client2.capture_output).to include @server.players[1].hand.join(' ')
      end

      it 'displays winner message' do
        @server.run_game
        expect(client1.capture_output).to match /win/i
        expect(client2.capture_output).to match /win/i
      end
    end
  end
end