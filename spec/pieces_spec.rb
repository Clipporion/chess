# frozen_string_literal: true

require './lib/pieces'
describe Pawn do
  subject(:pawn) { described_class.new('white', [1, 1]) }
  subject(:pawn_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white pawn' do
      expect(pawn.figure).to eq("\u2659")
      expect(pawn.moves).to eq([[2, 0], [1, 0]])
    end

    it 'creates a black pawn' do
      expect(pawn_b.figure).to eq("\u265f")
      expect(pawn_b.moves).to eq([[-2, 0], [-1, 0]])
    end
  end

  describe '#remove_double_jump' do
    describe 'removes the 2-field-move when a pawn has been moved' do
      it 'works with the white pawn' do
        pawn.remove_double_jump(pawn.color)
        expect(pawn.moves).to eq([[1, 0]])
      end

      it 'works with the black pawn' do
        pawn_b.remove_double_jump(pawn_b.color)
        expect(pawn_b.moves).to eq([[-1, 0]])
      end
    end
  end
end

describe King do
  subject(:king) { described_class.new('white', [1, 1]) }
  subject(:king_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white king' do
      expect(king.figure).to eq("\u2654")
    end

    it 'creates a black king' do
      expect(king_b.figure).to eq("\u265a")
    end
  end
end

describe Queen do
  subject(:queen) { described_class.new('white', [1, 1]) }
  subject(:queen_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white queen' do
      expect(queen.figure).to eq("\u2655")
    end

    it 'creates a black queen' do
      expect(queen_b.figure).to eq("\u265b")
    end
  end
end

describe Rook do
  subject(:rook) { described_class.new('white', [1, 1]) }
  subject(:rook_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white rook' do
      expect(rook.figure).to eq("\u2656")
    end

    it 'creates a black rook' do
      expect(rook_b.figure).to eq("\u265c")
    end
  end
end

describe Bishop do
  subject(:bishop) { described_class.new('white', [1, 1]) }
  subject(:bishop_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white bishop' do
      expect(bishop.figure).to eq("\u2657")
    end

    it 'creates a black bishop' do
      expect(bishop_b.figure).to eq("\u265d")
    end
  end
end

describe Knight do
  subject(:knight) { described_class.new('white', [1, 1]) }
  subject(:knight_b) { described_class.new('black', [1, 2]) }

  describe '#initialize' do
    it 'creates a white knight' do
      expect(knight.figure).to eq("\u2658")
    end

    it 'creates a black knight' do
      expect(knight_b.figure).to eq("\u265e")
    end
  end
end
