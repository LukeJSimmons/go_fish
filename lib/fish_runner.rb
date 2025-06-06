require_relative 'fish_game'

game = FishGame.new
game.start

until game.deck.cards.empty?
  puts "#{game.current_player.name}'s turn"
  # puts "You have #{game.current_player.hand.map(&:rank).sort}" unless game.current_player.name != "Player 1"
  puts "You have #{game.current_player.books.count} book#{"s" if game.current_player.books.count > 1}"

  # puts "Who would you like to target?"
  target = game.current_opponent.name
  target = game.players.find { |player| player.name == target }

  puts "What card would you like to request?"
  puts "You have #{game.current_player.hand.map(&:rank).sort}"
  request = gets.chomp
  request = game.current_player.hand.find { |card| card.rank == request }
  
  results = game.play_round(target, request)

  if results.is_a? Array
    puts "You took #{results.count} #{results.first.rank}#{"s" if results.count > 1}"
  else
    puts "Go fish: You drew a #{results.rank}"
  end
end
puts "#{game.determine_winner.name} wins with #{game.determine_winner.books.count} books"