require 'fish_game'
require 'card_deck'

describe 'FishGame' do
  let(:game) { FishGame.new }
  describe '#initialize' do
    it 'has a deck' do
      expect(game).to respond_to :deck
    end

    it 'deck is a CardDeck' do
      expect(game.deck).to respond_to :cards
    end

    it 'deck has BASE_DECK_SIZE cards' do
      expect(game.deck.cards.count).to eq BASE_DECK_SIZE
    end

    it 'has players' do
      expect(game).to respond_to :players
    end

    it 'has two players' do
      expect(game.players.count).to eq 2
    end

    it 'players are both FishPlayer objects' do
      expect(game.players.all? { |player| player.respond_to? :hand }).to eq true
    end
  end

  describe '#start' do
    it 'shuffles the deck' do
      unshuffled_deck = CardDeck.new
      expect(game.deck).to eq unshuffled_deck
      game.start
      expect(game.deck).to_not eq unshuffled_deck
    end

    it 'deals 7 cards to each player' do
      game.start
      expect(game.players.all? { |player| player.hand.count == 7 }).to eq true
    end
  end

  describe '#play_round' do

    context 'when opponent does have match' do
      before do
        game.current_player.add_card_to_hand(Card.new('A','H'))
        game.current_opponent.add_card_to_hand(Card.new('A','C'))
      end

      it "adds A of C to current player's hand" do
        game.play_round
        expect(game.current_player.hand.count).to eq 2
        expect(game.current_opponent.hand.count).to eq 0
      end

      it 'should not swap turns' do
        game.play_round
        expect(game.current_player).to eq game.players[0]
        expect(game.current_opponent).to eq game.players[1]
      end
    end

    context 'when opponent does not have match' do
      before do
        game.current_player.add_card_to_hand(Card.new('A','H'))
        game.current_opponent.add_card_to_hand(Card.new('9','C'))
      end

      it 'player should draw a card' do
        expect {
          game.play_round
        }.to change(game.current_player.hand, :count).by 1
      end

      it 'should swap turns' do
        game.play_round
        expect(game.current_player).to eq game.players[1]
        expect(game.current_opponent).to eq game.players[0]
      end
    end
  end

  describe '#play_game' do
    before do
      game.start
    end

    it 'plays until the deck is empty' do
      game.play_game
      expect(game.deck.cards.count).to eq 0
    end
  end

  describe '#determine_winner' do
    it 'returns the player 1 if he has most books' do
      game.players.first.add_card_to_hand(Card.new('A','H'))
      game.players.first.add_card_to_hand(Card.new('A','D'))
      game.players.first.add_card_to_hand(Card.new('A','C'))
      game.players.first.add_card_to_hand(Card.new('A','S'))
      expect(game.determine_winner).to eq game.players.first
    end

    it 'returns the player 2 if he has most books' do
      game.players[1].add_card_to_hand(Card.new('A','H'))
      game.players[1].add_card_to_hand(Card.new('A','D'))
      game.players[1].add_card_to_hand(Card.new('A','C'))
      game.players[1].add_card_to_hand(Card.new('A','S'))
      expect(game.determine_winner).to eq game.players[1]
    end
  end

  describe '#current_player' do
    it 'should return Player 1 on first round' do
      expect(game.current_player).to eq game.players.first
    end
  end

  describe '#current_opponent' do
    it 'should return Player 2 on first round' do
      expect(game.current_opponent).to eq game.players[1]
    end
  end

  describe '#swap_turns' do
    it 'swaps current player and current opponent' do
      game.swap_turns
      expect(game.current_player).to eq game.players[1]
      expect(game.current_opponent).to eq game.players[0]
    end
  end
end