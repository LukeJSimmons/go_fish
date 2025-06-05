require 'card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }

  context '#initialize' do
    it 'has cards' do
      expect(deck).to respond_to :cards
    end
  end
end