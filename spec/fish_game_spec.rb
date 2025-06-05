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
  end
end