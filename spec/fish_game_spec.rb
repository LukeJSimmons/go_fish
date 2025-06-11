require 'fish_game'
require 'card_deck'

describe FishGame do
  let(:game) { FishGame.new }
  describe '#initialize' do
    it 'has a deck' do
      expect(game).to respond_to :deck
    end

    it 'deck is a CardDeck' do
      expect(game.deck).to respond_to :cards
    end

    it 'has players' do
      expect(game).to respond_to :players
    end

    it 'has two players' do
      expect(game.players.count).to eq 2
    end

    it 'both players are FishPlayer objects' do
      expect(game.players.all? { |player| player.respond_to? :hand }).to eq true
    end

    it 'has round' do
      expect(game).to respond_to :round
    end
  end

  describe '#start' do
    it 'shuffles the deck' do
      unshuffled_deck = CardDeck.new
      expect(game.deck).to eq unshuffled_deck
      game.start
      expect(game.deck).to_not eq unshuffled_deck
    end

    it 'deals BASE_HAND_SIZE cards to each player' do
      game.start
      # binding.irb
      expect(game.players.all? { |player| player.hand.count == FishGame::BASE_HAND_SIZE }).to eq true
    end
  end

  describe '#play_round' do
    let(:default_target) { game.current_opponents.first }
    let(:default_rank) { game.current_player.request_card }

    context 'when opponent does have match' do
      before do
        game.current_player.add_cards_to_hand(Card.new('A', 'H'))
        game.players[1].add_cards_to_hand(Card.new('A', 'C'))
      end

      it "adds A of C to current player's hand" do
        game.play_round(default_target, default_rank)
        expect(game.current_player.hand.count).to eq 2
        expect(game.players[1].hand.count).to eq 0
      end

      it 'should not swap turns' do
        game.play_round(default_target, default_rank)
        expect(game.current_player).to eq game.players[0]
      end
    end

    context 'when opponent does not have match' do
      before do
        game.current_player.add_cards_to_hand(Card.new('A', 'H'))
        game.players[1].add_cards_to_hand(Card.new('9', 'C'))
      end

      it 'player should draw a card' do
        expect do
          game.play_round(default_target, default_rank)
        end.to change(game.current_player.hand, :count).by 1
      end

      it 'removes a card from the deck' do
        expect do
          game.play_round(default_target, default_rank)
        end.to change(game.deck.cards, :count).by(-1)
      end

      context 'when drawn card is not what he requested' do
        before do
          allow(game.deck).to receive(:draw_card).and_return(Card.new('8', 'S'))
        end

        it 'should swap turns' do
          game.play_round(default_target, default_rank)
          expect(game.current_player).to_not eq game.players[0]
        end
      end

      context 'when drawn card is what he requested' do
        before do
          allow(game.deck).to receive(:draw_card).and_return(Card.new('A', 'S'))
        end

        it 'should not swap turns' do
          game.play_round(default_target, default_rank)
          expect(game.current_player).to eq game.players[0]
        end
      end
    end
  end

  describe '#determine_winner' do
    context 'when player 1 has the most books' do
      before do
        game.players.first.add_cards_to_hand([
                                               Card.new('A', 'H'),
                                               Card.new('A', 'D'),
                                               Card.new('A', 'C'),
                                               Card.new('A', 'S')
                                             ])
      end

      it 'returns the player 1' do
        expect(game.determine_winner).to eq game.players.first
      end
    end

    context 'when player 2 has the most books' do
      before do
        game.players[1].add_cards_to_hand([
                                            Card.new('A', 'H'),
                                            Card.new('A', 'D'),
                                            Card.new('A', 'C'),
                                            Card.new('A', 'S'),
                                            Card.new('9', 'H'),
                                            Card.new('9', 'D'),
                                            Card.new('9', 'C'),
                                            Card.new('9', 'S')
                                          ])
      end

      it 'returns the player 2 if he has most books' do
        expect(game.determine_winner).to eq game.players[1]
      end
    end

    context 'when players are tied for amount of books' do
      context 'when player 1 has highest rank book' do
        before do
          game.players.first.add_cards_to_hand([
                                                 Card.new('A', 'H'),
                                                 Card.new('A', 'D'),
                                                 Card.new('A', 'C'),
                                                 Card.new('A', 'S')
                                               ])
          game.players[1].add_cards_to_hand([
                                              Card.new('2', 'H'),
                                              Card.new('2', 'D'),
                                              Card.new('2', 'C'),
                                              Card.new('2', 'S')
                                            ])
        end
        it 'returns player 1' do
          expect(game.determine_winner).to eq game.players.first
        end
      end

      context 'when player 2 has highest rank book' do
        before do
          game.players.first.add_cards_to_hand([
                                                 Card.new('2', 'H'),
                                                 Card.new('2', 'D'),
                                                 Card.new('2', 'C'),
                                                 Card.new('2', 'S')
                                               ])
          game.players[1].add_cards_to_hand([
                                              Card.new('A', 'H'),
                                              Card.new('A', 'D'),
                                              Card.new('A', 'C'),
                                              Card.new('A', 'S')
                                            ])
        end

        it 'returns player 2' do
          expect(game.determine_winner).to eq game.players[1]
        end
      end
    end
  end

  describe '#current_player' do
    let(:default_target) { game.current_opponents.first }
    let(:default_rank) { game.current_player.request_card }
    
    it 'should return Player 1 on first round' do
      expect(game.current_player).to eq game.players.first
    end

    it 'should return Player 2 on second round' do
      game.play_round(default_target, default_rank)
      expect(game.current_player).to eq game.players[0]
    end
  end
end
