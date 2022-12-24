# frozen_string_literal: true

# This class will be used to store all the methods every chess piece
# will utilize.
class Pieces
  attr_reader :color, :moves, :figure, :mode
  attr_accessor :possible_moves, :location

  def initialize(color, location)
    @color = color
    @possible_moves = []
    @figure = create_figure(@color)
    @location = location
    @mode = ''
  end

  def valid_target?(target_node)
    return true if moves.include?(target_node.location)
  end

  def create_black_figures
    case self
    when King then "\u2654"
    when Queen then "\u2655"
    when Rook then "\u2656"
    when Bishop then "\u2657"
    when Knight then "\u2658"
    when Pawn then "\u2659"
    end
  end

  def create_white_figures
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

  def fill_possible_moves(board, mode = @mode, start = location, color = board[start].piece.color)
    @moves.each do |move|
      if mode == 'single'
        x = (start[0].ord + move[0]).chr
        y = start[1] + move[1]
        break if board[[x, y]].piece.color == color

        @possible_moves << [x, y] if ('a'..'g').include?(x) && (1..8).include?(y)
      else
        build_move_array(start, move)
      end
    end
  end

  def build_move_array(start, move, x_axis = (start[0].ord + move[0]).chr, y_axis = start[1] + move[1])
    while ('a'..'h').include?(x_axis) && (1..8).include?(y_axis)
      @possible_moves << [x_axis, y_axis]
      x_axis = (x_axis.ord + move[0]).chr
      y_axis += move[1]
    end
  end
end

# This is the class used for all the pawn pieces.
class Pawn < Pieces
  def initialize(color, location)
    super
    @moves = create_pawn_moves(@color)
    @mode = 'single'
  end

  def create_pawn_moves(color)
    if color == 'white'
      [[0, 1], [0, 2]]
    else
      [[0, -1], [0, -2]]
    end
  end

  def remove_double_jump(color)
    if color == 'white'
      @moves.delete([0, 2])
    else
      @moves.delete([0, -2])
    end
  end
end

# This is the class used for all the knight pieces.
class Knight < Pieces
  def initialize(color, location)
    super
    @moves = [[-1, -2], [1, -2], [-1, 2], [1, 2], [-2, -1], [2, -1], [-2, 1], [2, 1]]
    @mode = 'single'
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
  attr_accessor :was_moved

  def initialize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @was_moved = false
  end
end

# This is the class used for all the queen pieces.
class Queen < Pieces
  def initialize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

# This is the class used for all the king pieces.
class King < Pieces
  attr_accessor :was_moved

  def initialize(color, location)
    super
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1]]
    @was_moved = false
  end
end

# This class will be used for empty fields on the board.
class Empty
  attr_reader :location, :color, :figure

  def initialize(location)
    @location = location
    @color = 'none'
    @figure = ' '
  end
end
