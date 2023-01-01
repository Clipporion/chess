# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces'
require_relative 'node'

# This is the class where all the input and game logic will be stored.
class Game
  attr_accessor :board, :turn, :current_color, :white_pieces, :black_pieces, :check_mate
  attr_reader :white_king, :black_king

  def initialize
    @board = Board.new
    @current_color = 'white'
    @check_mate = false
    @turn = 0
    @black_king = @board.board[['e', 8]].piece
    @white_king = @board.board[['e', 1]].piece
    @white_pieces = fill_pieces('white')
    @black_pieces = fill_pieces('black')
    @check_mate = false
  end

  def fill_pieces(color)
    res = []
    @board.board.each_value do |node|
      res << node.piece if node.piece.color == color && !node.piece.is_a?(King)
    end
    res
  end

  def user_input
    puts "#{@current_color.capitalize} player, please enter start field and target field:"
    input = gets.chomp
    if input.include?(' ')
      start = cleanup_input(input.split[0].split(''))
      target = cleanup_input(input.split[1].split(''))
      [start, target]
    else
      user_input
    end
  end

  def cleanup_input(input)
    first = input[0].downcase
    second = input[1].to_i
    [first, second]
  end

  def valid?(input)
    return true if ('a'..'h').include?(input[0]) && (1..8).include?(input[1])

    false
  end

  def check_moves(start, target)
    @board.board[start].piece.fill_possible_moves(@board.board)
    moves = @board.board[start].piece.possible_moves
    moves.each_value do |move|
      return true if move.include?(target) || move == target
    end
    false
  end

  def check_color(start)
    piece_color = @board.board[start].piece.color
    return true if piece_color == @current_color

    false
  end

  def everything_valid?(start, target)
    return true if valid?(start) && valid?(target) && check_color(start) && check_moves(start, target)

    false
  end

  def move_piece(start, target, target_piece = @board.board[target].piece, start_piece = @board.board[start].piece)
    update_board(start_piece, target_piece)
    kings_in_check
    unless (@current_color == 'white' && !@white_king.is_checked) ||
           (@current_color == 'black' && !@black_king.is_checked)
      reset(start, target, start_piece, target_piece)
    end
  end

  def reset(start, target, start_piece, target_piece)
    puts "#{start_piece.color.capitalize} player, this move would put your king in check!"
    target_piece.location = target
    @board.board[target].piece = target_piece
    start_piece.location = start
    @board.board[start].piece = start_piece
    @white_pieces.push(target_piece) if target_piece.color == 'white'
    @black_pieces.push(target_piece) if target_piece.color == 'black'
    player_turn
  end

  def update_board(start_piece, target_piece)
    @board.board[target_piece.location].piece = start_piece
    @board.board[start_piece.location].piece = Empty.new(start_piece.location)
    start_piece.location = target_piece.location
    start_piece.was_moved = true
    delete_piece(target_piece)
  end

  def delete_piece(target_piece)
    @white_pieces.delete(target_piece) if @white_pieces.include?(target_piece)
    @black_pieces.delete(target_piece) if @black_pieces.include?(target_piece)
  end

  def kings_in_check
    @white_king.fill_possible_moves(@board.board)
    @black_king.fill_possible_moves(@board.board)
    king_check(@black_pieces, @white_king)
    king_check(@white_pieces, @black_king)
  end

  def king_check(pieces, king)
    king.attacking_lines = {}
    pieces.each do |piece|
      compare_moves(piece, king)
    end
    update_in_check(king)
  end

  def compare_moves(piece, king)
    piece.fill_possible_moves(@board.board)
    piece.possible_moves.each_value do |move_line|
      if move_line == king.location || move_line.include?(king.location)
        king.attacking_lines[piece.location] = move_line
      end
      remove_king_move(king, move_line)
    end
    p king.possible_moves
    p king.attacking_lines
  end

  def remove_king_move(king, move_line)
    king.possible_moves.each do |key, value|
      king.possible_moves.delete(key) if move_line.include?(value) || move_line == value
    end
  end

  def update_in_check(king)
    king.is_checked = king.attacking_lines.length.positive? ? true : false
  end

  def switch_player
    return @current_color = 'black' if @current_color == 'white'

    @current_color = 'white'
  end

  def player_turn(input = user_input, start = input[0], target = input[1])
    if everything_valid?(start, target)
      move_piece(start, target)
    else
      puts 'Incorrect input'
      player_turn
    end
  end

  def call_check
    if @current_color == 'white' && @black_king.is_checked
      check_mate?(@black_king, @black_pieces)
      p 'Black player, your king is in check!' unless @check_mate
    elsif @current_color == 'black' && @white_king.is_checked
      check_mate?(@white_king, @white_pieces)
      p 'White player, your king is in check!' unless @check_mate
    end
  end

  def check_mate?(king, pieces)
    return unless king.possible_moves.empty?

    king.attacking_lines.each do |attacker, attacking_line|
      pieces.each do |piece|
        piece.fill_possible_moves(@board.board)
        return @check_mate = false if defended?(attacker, attacking_line, piece.possible_moves)
      end
    end
    @check_mate = true
    puts "#{king.color.capitalize} player, you are check mate!"
  end

  def defended?(attacker, attacking_line, moveset)
    return true if moveset == attacker || moveset.include?(attacker)

    moveset.each do |move|
      return true if move == attacking_line

      attacking_line.each do |attacking_move|
        return true if move == attacking_move
      end
    end
    false
  end

  def play_round
    player_turn
    system('clear')
    @board.display
    call_check
    switch_player
    @turn += 1
  end
end

system('clear')
game = Game.new
game.board.display

game.play_round until game.check_mate
