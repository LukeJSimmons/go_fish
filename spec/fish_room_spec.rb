require 'fish_room'
require 'fish_game'

describe FishRoom do
  let(:room) { FishRoom.new(FishGame.new) }
  describe '#initialize' do
    it 'has a game' do
      expect(room).to respond_to :game
    end
  end
end