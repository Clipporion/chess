# frozen_string_literal: true

# This module includes all the logic required for the rochade moves
module Rochade
  def rochade(input)
    king = current_color == 'white' ? @white_king : @black_king
    rook = gather_rook(input)

    if rook.is_a?(Rook) && !king.was_moved && !rook.was_moved
      check_rochade(king, rook, input)
    else
      puts "#{input.capitalize} Rochade not possible"
      player_turn
    end
  end

  def gather_rook(input)
    case input
    when 'short'
      rook = current_color == 'white' ? @board.board[['h', 1]].piece : @board.board[['h', 8]].piece
    when 'long'
      rook = current_color == 'white' ? @board.board[['a', 1]].piece : @board.board[['a', 8]].piece
    end
    rook
  end

  def check_rochade(king, rook, input)
    if input == 'short'
      short_rochade_move(king, rook, input)
    else
      long_rochade_move(king, rook, input)
    end
  end

  def short_rochade_move(king, rook, input)
    if @current_color == 'white' && check_white_fields_short
      move_king_short_white(king, rook)
    elsif @current_color == 'black' && check_black_fields_short
      move_king_short_black(king, rook)
    else
      puts "#{input.capitalize} Rochade not possible, a piece is in the way."
      player_turn
    end
  end

  def check_white_fields_short
    return true if @board.board[['f', 1]].piece.color == 'none' && @board.board[['g', 1]].piece.color == 'none'

    false
  end

  def check_black_fields_short
    return true if @board.board[['f', 8]].piece.color == 'none' && @board.board[['g', 8]].piece.color == 'none'

    false
  end

  def move_king_short_white(king, rook)
    player_turn(user_input('e1 f1'), 'r')
    player_turn(user_input('f1 g1'), 'r') if king.location == ['f', 1]
    if king.location == ['g', 1]
      move_rook_short(rook)
    else
      reset_king(king)
      player_turn
    end
  end

  def move_king_short_black(king, rook)
    player_turn(user_input('e8 f8'), 'r')
    player_turn(user_input('f8 g8'), 'r') if king.location == ['f', 8]
    if king.location == ['g', 8]
      move_rook_short(rook)
    else
      reset_king(king)
      player_turn
    end
  end

  def reset_king(king, start = @board.board[king.location])
    case @current_color
    when 'white'
      start.piece = Empty.new(king.location)
      @board.board[['e', 1]].piece = king
      king.location = ['e', 1]
    when 'black'
      start.piece = Empty.new(rook.location)
      @board.board[['e', 8]].piece = king
      king.location = ['e', 8]
    end
  end

  def move_rook_short(rook, start = @board.board[rook.location])
    case @current_color
    when 'white'
      start.piece = Empty.new(rook.location)
      @board.board[['f', 1]].piece = rook
      rook.location = ['f', 1]
    when 'black'
      start.piece = Empty.new(rook.location)
      @board.board[['f', 8]].piece = rook
      rook.location = ['f', 8]
    end
  end
end
