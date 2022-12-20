# frozen_string_literal: true

require './lib/node'

describe Node do
  subject(:node) { described_class.new(['a', 1]) }

  describe '#initialize' do
    it 'sets the neighbors right' do
      left_node = node.left
      right_node = node.right
      up_node = node.up

      expect(left_node).to eq(nil)
      expect(right_node).to eq(['b', 1])
      expect(up_node).to eq(['a', 2])
    end
  end
end
