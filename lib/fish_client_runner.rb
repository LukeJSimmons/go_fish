require 'socket'

socket = TCPSocket.new('localhost', 3000)
loop do
  output = ""
  until output != ""
    begin
      sleep(0.1)
      output = socket.read_nonblock(1000).chomp
    rescue IO::WaitReadable
    end
  end
  if output.include? ":"
    print output + ' '
    socket.puts(gets.chomp)
  else
    puts output
  end
end