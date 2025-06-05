require 'fish_game'

describe 'FishGame' do
  let(:game) { FishGame.new }
  describe '#initialize' do
    it 'has a deck' do
      expect(game).to respond_to :deck
    end

    it 'deck is a CardDeck' do
      expect(game.deck).to respond_to :cards
    end

    it 'has players' do
      expect(game).to respond_to :players
    end

    it 'has two players' do
      expect(game.players.count).to eq 2
    end

    it 'players are both FishPlayer objects' do
      expect(game.players.all? { |player| player.respond_to? :hand }).to eq true
    end
  end
end