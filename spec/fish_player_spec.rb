require 'fish_player'

describe 'FishPlayer' do
  let(:player) { FishPlayer.new }

  describe '#initialize' do
    it 'has a hand' do
      expect(player).to respond_to :hand
    end
  end
end