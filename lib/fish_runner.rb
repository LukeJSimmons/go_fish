require_relative 'fish_game'

game = FishGame.new
game.start

until game.deck.cards.empty?
  puts "You have #{game.current_player.hand.map(&:rank).sort}" unless game.current_player.name != "Player 1"
  puts "You have #{game.current_player.books.count} books"
  game.play_round
end
puts "#{game.determine_winner.name} wins with #{game.determine_winner.books.count} books"