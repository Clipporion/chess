# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces'
require_relative 'node'

# This is the class where all the input and game logic will be stored.
class Game
  attr_accessor :board, :turn, :current_color, :white_pieces, :black_pieces
  attr_reader :white_king, :black_king

  def initialize
    @board = Board.new
    @current_color = 'white'
    @check = false
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
      res << node.piece if node.piece.color == color
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
    @board.board[target].piece = Empty.new(start)
    @board.board[start].piece = Empty.new(start)
    kings_in_check
    if (@current_color == 'white' && !@white_king.is_checked) || (@current_color == 'black' && !@black_king.is_checked)
      update_board(start_piece, target_piece)
    else
      reset(start, target, start_piece, target_piece)
    end
  end

  def reset(start, target, start_piece, target_piece)
    puts "#{start_piece.color.capitalize} player, this move would put your king in check!"
    @board.board[target].piece = target_piece
    @board.board[start].piece = start_piece
    @white_king.is_checked = false if @current_color == 'white'
    @black_king.is_checked = false if @current_color == 'black'
    player_turn
  end

  def update_board(start_piece, target_piece)
    @board.board[target_piece.location].piece = start_piece
    start_piece.location = target_piece.location
    start_piece.was_moved = true
    @white_pieces.delete(target_piece) if @white_pieces.include?(target_piece)
    @black_pieces.delete(target_piece) if @black_pieces.include?(target_piece)
  end

  def kings_in_check
    king_check(@black_pieces, @white_king)
    king_check(@white_pieces, @black_king)
  end

  def king_check(pieces, king)
    pieces.each do |piece|
      piece.fill_possible_moves(@board.board)
      piece.possible_moves.each_value do |move_line|
        if move_line == king.location || move_line.include?(king.location)
          king.is_checked = true
        end
      end
    end
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
      puts 'Black player, your king is in check!'
    elsif @current_color == 'black' && @white_king.is_checked
      puts 'White player, your king is in check!'
    end
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
game.play_round until game.turn == 10
