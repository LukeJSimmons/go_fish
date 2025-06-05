require 'card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }

  describe '#initialize' do
    it 'has cards' do
      expect(deck).to respond_to :cards
    end

    it 'has only card objects in cards' do
      expect(deck.cards.all? { |card| card.respond_to?(:rank) }).to eq true
    end

    it 'starts with base amount of cards' do
      expect(deck.cards.count).to eq BASE_DECK_SIZE
    end
  end

  describe '#draw_card' do
    it 'removes a card from cards' do
      expect { deck.draw_card }.to change(deck.cards, :count).by (-1)
    end

    it 'removes the last card from cards' do
      expect(deck.draw_card).to eq deck.cards.last
    end
  end
end