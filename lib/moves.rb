# frozen_string_literal: true

# This module includes all the methods relevant for when a piece moves
module Moves
  def move_piece(start, target, mod, target_piece = @board.board[target].piece, start_piece = @board.board[start].piece)
    update_board(start_piece, target_piece)
    kings_in_check
    unless (@current_color == 'white' && !@white_king.is_checked) ||
           (@current_color == 'black' && !@black_king.is_checked)
      reset(start, target, start_piece, target_piece, mod)
    end
  end

  def reset(start, target, start_piece, target_piece, mode)
    puts "#{start_piece.color.capitalize} player, this move would put your king in check!"
    target_piece.location = target
    @board.board[target].piece = target_piece
    start_piece.location = start
    @board.board[start].piece = start_piece
    return_piece(target_piece)
    player_turn unless mode == 'r'
  end

  def return_piece(target_piece)
    @white_pieces.push(target_piece) if target_piece.color == 'white'
    @black_pieces.push(target_piece) if target_piece.color == 'black'
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
end
