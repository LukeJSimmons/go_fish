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
    end
  end
end