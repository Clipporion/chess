# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces'
require_relative 'node'

# This is the class where all the input and game logic will be stored.
class Game
  attr_accessor :board, :turn, :current_color
  attr_reader :white_king, :black_king

  def initialize
    @board = Board.new
    @current_color = 'white'
    @check = false
    @turn = 0
    @black_king = @board.board[['e', 8]].piece
    @white_king = @board.board[['e', 1]].piece
    @check_mate = false
  end

  def user_input
    puts "#{@current_color.capitalize} player, please enter start field and target field:"
    input = gets.chomp
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
    p moves
    return true if moves.include?(target)

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

  def move_piece(start, target)
    @board.board[target].piece = @board.board[start].piece
    @board.board[start].piece = Empty.new(start)
    reset_piece_variables(target)
    check(@board.board[target].piece)
  end

  def check(piece)
    piece.possible_moves = []
    if piece.color == 'white'
      check_king(piece, @black_king)
    else
      check_king(piece, @white_king)
    end
    piece.possible_moves = []
  end

  def check_king(attacker, king)
    attacker.fill_possible_moves(@board.board)
    return unless attacker.possible_moves.include?(king.location)

    king.is_checked = true
    king.possible_moves.each do |move|
      king.possible_moves.delete(move) if attacker.possible_moves.include?(move)
    end
    check_mate(attacker, king)
  end

  def find_checking_line(attacker, location)
    res = []
    attacker.possible_moves = []
    attacker.moves.each do |move|
      build_move_multi(@board.board, @location, move)
      if attacker.possible_moves.include?(location)
        res = attacker.possible_moves
        attacker.possible_moves = []
      end
    end
  end

  def check_mate(attacker, king)
    checking_line = find_checking_line(attacker, king.location)
    if king.possible_moves.empty?
      @check_mate = true
      puts "#{king.color.capitalize} player, you are check mate!"
    else
      puts "#{king.color.capitalize} player, you are check!"
    end
  end

  def reset_piece_variables(target)
    piece = @board.board[target].piece
    piece.is_checked = false if piece.mode == 'king'
    piece.location = target
    piece.was_moved = true
  end

  def switch_player
    return @current_color = 'black' if @current_color == 'white'

    @current_color = 'white'
  end

  def player_turn(input = user_input, start = input[0], target = input[1])
    if everything_valid?(start, target)
      move_piece(start, target)
      switch_player
      @turn += 1
      @board.display
    else
      puts 'Incorrect input'
      player_turn
    end
  end
end

game = Game.new
game.board.display
until game.turn > 9 || check_mate
  game.player_turn
  p game.white_king
  p game.black_king
end
