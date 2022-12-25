# frozen_string_literal: true

require_relative 'board'
require_relative 'pieces'
require_relative 'node'

# This is the class where all the input and game logic will be stored.
class Game
  attr_accessor :board, :turn, :current_color

  def initialize
    @board = Board.new
    @current_color = 'white'
    @check = false
    @turn = 0
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
  end

  def reset_piece_variables(target)
    piece = @board.board[target].piece
    piece.possible_moves = []
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
until game.turn > 9
  game.player_turn
end
