# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces'
require_relative 'node'
require_relative 'moves'
require_relative 'rochade'
require 'yaml'
require 'psych'

# This is the class where all the input and game logic will be stored.
class Game
  include Rochade
  include Moves
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
  end

  def fill_pieces(color)
    res = []
    @board.board.each_value do |node|
      res << node.piece if node.piece.color == color && !node.piece.is_a?(King)
    end
    res
  end

  def save_game
    Dir.mkdir('savegame') unless Dir.exist?('savegame')
    File.open('./savegame/savegame.yaml', 'w') { |file| file.write(YAML.dump(self)) }
    @check_mate = true
  end

  def user_input(input = gets.chomp)
    if input.include?(' ')
      clean_input(input)
    elsif input == 'save'
      save_game
    elsif %w[short long].include?(input)
      input
    else
      user_input
    end
  end

  def clean_input(input)
    start = cleanup_input(input.split[0].split(''))
    target = cleanup_input(input.split[1].split(''))
    [start, target]
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

  def player_turn(input = user_input, mode = '')
    return if input == 'save'
    return rochade(input) if %w[long short].include?(input)

    start = input[0]
    target = input[1]
    if everything_valid?(start, target)
      move_piece(start, target, mode)
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
    puts "#{@current_color.capitalize} player, please enter start field and target field or long/short for a rochade:"
    player_turn
    system('clear')
    @board.display
    call_check
    switch_player
    @turn += 1
  end
end

puts 'Welcome to chess, please enter 1 to start a new game or 2 to load a saved game:'
input = gets.chomp.to_i until (1..2).include?(input)

game = input == 1 ? Game.new : Psych.unsafe_load(File.open('./savegame/savegame.yaml', 'r'))

system('clear')
game.board.display

game.play_round until game.check_mate
