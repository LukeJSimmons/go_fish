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
      expect(deck.cards.count).to eq CardDeck::BASE_DECK_SIZE
    end
  end

  describe '#draw_card' do
    it 'removes a card from cards' do
      expect { deck.draw_card }.to change(deck.cards, :count).by(-1)
    end

    it 'removes the last card from cards' do
      last_card = deck.cards.last
      expect(deck.draw_card).to eq last_card
    end
  end

  describe '#shuffle!' do
    it 'returns an array with size of cards array' do
      expect(deck.shuffle!.count).to eq deck.cards.count
    end

    it 'returns an array of Card objects' do
      expect(deck.shuffle!.all? { |card| card.respond_to?(:rank) }).to eq true
    end

    it 'returns a different array than cards' do
      unshuffled_deck = CardDeck.new
      expect(deck).to eq unshuffled_deck
      deck.shuffle!
      expect(deck).to_not eq unshuffled_deck
    end
  end
end
