require 'round_result'

describe RoundResult do
  let(:result) { RoundResult.new }
  describe '#initialize' do
    it 'has a current_player' do
      expect(result).to respond_to :current_player
    end

    it 'has a target_player' do
      expect(result).to respond_to :target_player
    end

    it 'has cards' do
      expect(result).to respond_to :cards
    end

    it 'has fished' do
      expect(result).to respond_to :fished
    end

    it 'has requested_rank' do
      expect(result).to respond_to :requested_rank
    end
  end
end