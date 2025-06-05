require 'fish_player'
require 'card'

describe 'FishPlayer' do
  let(:player) { FishPlayer.new }

  describe '#initialize' do
    it 'has a hand' do
      expect(player).to respond_to :hand
    end

    it 'has a name' do
      expect(player).to respond_to :name
    end

    it 'can take name as argument' do
      name = 'Player 1'
      expect(FishPlayer.new(name).name).to eq name
    end
  end

  describe '#add_card_to_hand' do
    it 'increases hand size by one' do
      expect {
        player.add_card_to_hand(Card.new('A','H'))
      }.to change(player.hand, :count).by 1
    end

    it 'adds a Card object to front of hand' do
      player.add_card_to_hand(Card.new('10','C'))

      new_card = Card.new('A','H')
      player.add_card_to_hand(new_card)
      expect(player.hand.first).to eq new_card
    end
  end

  describe '#request_card' do
    before do
      player.add_card_to_hand(Card.new('A','H'))
    end
    it 'returns a card from hand' do
      expect(player.hand).to include player.request_card
    end
  end
end