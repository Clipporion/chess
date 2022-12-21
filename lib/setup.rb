# frozen_string_literal: true

require_relative 'pieces'

# This module contains all the methods needed to create the initial
# chess board with all the pieces
module Setup
  def fill_board
    fill_kings
    fill_queens
    fill_rooks
    fill_bishops
    fill_knights
    fill_pawns
  end

  def fill_kings
    @board[['e', 1]].piece = King.new('white', @board[['e', 1]])
    @board[['e', 8]].piece = King.new('black', @board[['e', 8]])
  end

  def fill_queens
    @board[['d', 1]].piece = Queen.new('white', @board[['d', 1]])
    @board[['d', 8]].piece = Queen.new('black', @board[['d', 8]])
  end

  def fill_rooks
    @board[['a', 1]].piece = Rook.new('white', @board[['a', 1]])
    @board[['a', 8]].piece = Rook.new('black', @board[['a', 8]])
    @board[['h', 1]].piece = Rook.new('white', @board[['h', 1]])
    @board[['h', 8]].piece = Rook.new('black', @board[['h', 8]])
  end

  def fill_bishops
    @board[['c', 1]].piece = Bishop.new('white', @board[['c', 1]])
    @board[['c', 8]].piece = Bishop.new('black', @board[['c', 8]])
    @board[['f', 1]].piece = Bishop.new('white', @board[['f', 1]])
    @board[['f', 8]].piece = Bishop.new('black', @board[['f', 8]])
  end

  def fill_knights
    @board[['b', 1]].piece = Knight.new('white', @board[['b', 1]])
    @board[['b', 8]].piece = Knight.new('black', @board[['b', 8]])
    @board[['g', 1]].piece = Knight.new('white', @board[['g', 1]])
    @board[['g', 8]].piece = Knight.new('black', @board[['g', 8]])
  end

  def fill_pawns
    ('a'..'h').each do |row|
      @board[[row, 2]].piece = Pawn.new('white', @board[[row, 2]])
      @board[[row, 7]].piece = Pawn.new('black', @board[[row, 7]])
    end
  end
end
