require 'card'

describe 'Card' do
  let(:card) { Card.new }
  describe '#initialize' do
    it 'has a rank' do
      expect(card).to respond_to :rank
    end

    it 'has a suit' do
      expect(card).to respond_to :suit
    end
    
    context 'when card is A of H' do
      let(:card) { Card.new('A', 'H') }

      it 'has a rank of A' do
        expect(card.rank).to eq 'A'
      end

      it 'has a suit of H' do
        expect(card.suit).to eq 'H'
      end

      it 'throws an error unless rank is valid' do
        expect { Card.new('55', 'H') }.to raise_error StandardError
      end

      it 'throws an error unless suit is valid' do
        expect { Card.new('5', 'Z') }.to raise_error StandardError
      end
    end
  end

  describe '#==' do
    it 'compares rank and suit' do
      card1 = Card.new('A', 'H')
      card2 = Card.new('A', 'H')

      expect(card1).to eq card2
    end
  end
end