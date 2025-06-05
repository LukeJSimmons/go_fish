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

  describe '#get_matching_card' do
    before do
      player.add_card_to_hand(Card.new('A','H'))
    end

    it 'returns all matching cards' do
      card_request = Card.new('A','C')
      expect(player.get_matching_cards(card_request)).to eq [Card.new('A','H')]
    end

    it 'returns an empty array if no matching cards' do
      card_request = Card.new('9','C')
      expect(player.get_matching_cards(card_request)).to eq []
    end
  end

  describe '#has_card?' do
    before do
      player.add_card_to_hand(Card.new('A','H'))
    end

    it 'returns false if player does not have card in hand' do
      expect(player.has_card?(Card.new('4','H'))).to eq false
    end

    it 'returns true if player does have card in hand' do
      expect(player.has_card?(Card.new('A','H'))).to eq true
    end
  end
end