class FishSocketServer
  def port_number
    3000
  end
  
  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end
end