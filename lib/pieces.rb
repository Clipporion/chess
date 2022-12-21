# frozen_string_literal: true

# This class will be used to store all the methods every chess piece
# will utilize.
class Pieces
  attr_reader :color, :moves, :figure
  attr_accessor :possible_moves, :location

  def initialize(color, location)
    @color = color
    @possible_moves = []
    @figure = create_figure(@color)
    @location = location
  end

  def valid_target?(target_node)
    return true if moves.include?(target_node.location)
  end

  def create_white_figures
    case self
    when King then "\u2654"
    when Queen then "\u2655"
    when Rook then "\u2656"
    when Bishop then "\u2657"
    when Knight then "\u2658"
    when Pawn then "\u2659"
    end
  end

  def create_black_figures
    case self
    when King then "\u265a"
    when Queen then "\u265b"
    when Rook then "\u265c"
    when Bishop then "\u265d"
    when Knight then "\u265e"
    when Pawn then "\u265f"
    end
  end

  def create_figure(color)
    if color == 'white'
      create_white_figures
    else
      create_black_figures
    end
  end
end

# This is the class used for all the pawn pieces.
class Pawn < Pieces
  def initialize(color, location)
    super
    @moves = create_pawn_moves(@color)
  end

  def create_pawn_moves(color)
    if color == 'white'
      [[2, 0], [1, 0]]
    else
      [[-2, 0], [-1, 0]]
    end
  end

  def remove_double_jump(color)
    if color == 'white'
      @moves.delete([2, 0])
    else
      @moves.delete([-2, 0])
    end
  end
end

# This is the class used for all the knight pieces.
class Knight < Pieces
  def initialize(color, location)
    super
    @moves = [[-1, -2], [1, -2], [-1, 2], [1, 2], [-2, -1], [2, -1], [-2, 1], [2, 1]]
  end
end

# This is the class used for all the bishop pieces.
class Bishop < Pieces
  def initialize(color, location)
    super
    @moves = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

# This is the class used for all the rook pieces.
class Rook < Pieces
  def initialize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

# This is the class used for all the queen pieces.
class Queen < Pieces
  def initalize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

# This is the class used for all the king pieces.
class King < Pieces
  def initalize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end
