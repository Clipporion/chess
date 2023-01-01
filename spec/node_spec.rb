# frozen_string_literal: true

require './lib/node'

describe Node do
  subject(:node) { described_class.new(['a', 1]) }

  describe '#initialize' do
    it 'sets the piece right' do
      piece = node.location

      expect(piece).to eq(['a',1])
    end
  end
end
