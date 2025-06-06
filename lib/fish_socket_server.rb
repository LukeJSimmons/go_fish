class FishSocketServer
  def port_number
    3000
  end

  def clients
    @clients ||= []
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
  end
end