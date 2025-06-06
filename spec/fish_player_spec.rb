require 'fish_player'
require 'card'

describe 'FishPlayer' do
  let(:player) { FishPlayer.new }

  describe '#initialize' do
    it 'has a hand' do
      expect(player).to respond_to :hand
    end

    it 'has books' do
      expect(player).to respond_to :books
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
      player.add_card_to_hand(Card.new('10','H'))
      player.add_card_to_hand(Card.new('Q','H'))
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

  describe '#has_book?' do
    context 'when player does not have book' do
      before do
        player.add_card_to_hand(Card.new('A','H'))
        player.add_card_to_hand(Card.new('A','C'))
        player.add_card_to_hand(Card.new('A','D'))
        player.add_card_to_hand(Card.new('10','S'))
      end

      it 'should return an empty array' do
        expect(player.has_book?).to eq []
      end
    end

    context 'when player does have a book' do
      before do
        player.add_card_to_hand(Card.new('A','H'),false)
        player.add_card_to_hand(Card.new('A','D'),false)
        player.add_card_to_hand(Card.new('A','C'),false)
        player.add_card_to_hand(Card.new('A','S'),false)
      end

      it 'should return array of matching cards' do
        expect(player.has_book?).to match_array [
          Card.new('A','H'),
          Card.new('A','D'),
          Card.new('A','C'),
          Card.new('A','S')
        ]
      end
    end
  end

  describe '#check_for_book' do
    context 'when player does have book' do
      before do
        player.add_card_to_hand(Card.new('A','H'),false)
        player.add_card_to_hand(Card.new('A','D'),false)
        player.add_card_to_hand(Card.new('A','C'),false)
        player.add_card_to_hand(Card.new('A','S'),false)
      end

      it 'removes the book from the hand' do
        expect {
          player.check_for_book
        }.to change(player.hand, :count).by (-4)
      end

      it 'adds the book to books' do
        expect {
          player.check_for_book
        }.to change(player.books, :count).by 1
      end
    end

    context 'when player does not have book' do
      before do
        player.add_card_to_hand(Card.new('A','H'))
        player.add_card_to_hand(Card.new('A','D'))
        player.add_card_to_hand(Card.new('A','C'))
        player.add_card_to_hand(Card.new('10','S'))
      end

      it 'does not remove the book from the hand' do
        expect {
          player.check_for_book
        }.to_not change(player.hand, :count)
      end
    end
  end
end