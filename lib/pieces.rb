# frozen_string_literal: true

# This class will be used to store all the methods every chess piece
# will utilize.
class Pieces
  attr_reader :color, :moves, :figure, :mode
  attr_accessor :possible_moves, :location, :was_moved, :is_checked

  def initialize(color, location)
    @color = color
    @possible_moves = {}
    @figure = create_figure(@color)
    @location = location
    @mode = ''
    @was_moved = false
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

  def fill_possible_moves(board, mode = @mode, start = @location)
    case mode
    when 'king' then fill_possible_moves(board, 'single') unless @is_checked == true
    when 'pawn' then build_moves_pawn(board, start)
    when 'single' then @moves.each { |key, value| build_moves(board, start, key, value) }
    else @moves.each { |key, value| build_move_multi(board, key, value) }
    end
  end

  def build_moves_pawn(board, start)
    remove_double_jump if @was_moved == true
    fill_possible_moves(board, 'single')
    remove_impossible(board)
    check_diagonal_moves(board, start)
  end

  def remove_impossible(board)
    @possible_moves.each do |_, value|
      @possible_moves.delete(value) if board[value].piece.figure != ' '
    end
  end

  def check_diagonal_moves(board, start)
    case @color
    when 'white'
      check_diagonal(board, start, :rightup, 1, 1)
      check_diagonal(board, start, :leftup, -1, 1)
    when 'black'
      check_diagonal(board, start, :rightdown, 1, -1)
      check_diagonal(board, start, :leftdown, -1, -1)
    end
  end

  def check_diagonal(board, start, name, x_modificator, y_modificator)
    x = (start[0].ord + x_modificator).chr
    y = start[1] + y_modificator
    return unless ('a'..'g').include?(x) && (1..8).include?(y)

    diagonal_field = board[[x, y]]
    @possible_moves[name] = [x, y] if diagonal_field.piece.color != 'none' && diagonal_field.piece.color != @color
  end

  def build_moves(board, start, key, value)
    x = (start[0].ord + value[0]).chr
    y = start[1] + value[1]
    @possible_moves[key] = [x, y] if ('a'..'h').include?(x) && (1..8).include?(y) && board[[x, y]].piece.color != @color
  end

  def build_move_multi(board, key, value, x_axis = (@location[0].ord + value[0]).chr, y_axis = @location[1] + value[1])
    res = []
    while ('a'..'h').include?(x_axis) && (1..8).include?(y_axis)
      piece_color = board[[x_axis, y_axis]].piece.color
      break if piece_color == @color

      res << [x_axis, y_axis]
      x_axis = (x_axis.ord + value[0]).chr
      y_axis += value[1]
      break if piece_color != 'none'
    end
    @possible_moves[key] = res
  end
end

# This is the class used for all the pawn pieces.
class Pawn < Pieces
  def initialize(color, location)
    super
    @moves = create_pawn_moves(@color)
    @mode = 'pawn'
  end

  def create_pawn_moves(color)
    if color == 'white'
      { up: [0, 1], double: [0, 2] }
    else
      { down: [0, -1], double: [0, -2] }
    end
  end

  def remove_double_jump
    @moves.delete(:double)
  end
end

# This is the class used for all the knight pieces.
class Knight < Pieces
  def initialize(color, location)
    super
    @moves = { first: [-1, -2], second: [1, -2], third: [-1, 2], forth: [1, 2], fifth: [-2, -1],
               sixth: [2, -1], seventh: [-2, 1], eighth: [2, 1] }
    @mode = 'single'
  end
end

# This is the class used for all the bishop pieces.
class Bishop < Pieces
  def initialize(color, location)
    super
    @moves = { rightup: [1, 1], leftup: [-1, 1], rightdown: [1, -1], leftdown: [-1, -1] }
  end
end

# This is the class used for all the rook pieces.
class Rook < Pieces
  attr_accessor :was_moved

  def initialize(color, location)
    super
    @moves = { right: [1, 0], left: [-1, 0], up: [0, 1], down: [0, -1] }
  end
end

# This is the class used for all the queen pieces.
class Queen < Pieces
  def initialize(color, location)
    super
    @moves = { right: [1, 0], left: [-1, 0], up: [0, 1], down: [0, -1],
               rightup: [1, 1], leftup: [-1, 1], rightdown: [1, -1], leftdown: [-1, -1] }
  end
end

# This is the class used for all the king pieces.
class King < Pieces
  attr_accessor :was_moved

  def initialize(color, location)
    super
    @moves = { right: [1, 0], left: [-1, 0], up: [0, 1], down: [0, -1],
               rightup: [1, 1], leftup: [-1, 1], rightdown: [1, -1], leftdown: [-1, -1] }
    @mode = 'single'
    @is_checked = false
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
