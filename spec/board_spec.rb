# frozen_string_literal: true

require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates a board of 64 nodes' do
      board_size = board.board.size

      expect(board_size).to eq(64)
    end

    it 'contains the node ["a", 1]' do
      expect(board.board.keys).to include(['a', 1])
    end
  end
end
