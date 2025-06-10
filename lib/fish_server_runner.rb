require_relative 'fish_socket_server'

server = FishSocketServer.new
server.start
puts "#{server} started on port #{server.port_number}"
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  if game
    room = server.create_room(game)
    room.run_game
  end
rescue
  server.stop
end