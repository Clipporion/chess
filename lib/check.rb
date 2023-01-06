# frozen_string_literal: true

# This module include the logic for check and check mate.
module Check
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
end
