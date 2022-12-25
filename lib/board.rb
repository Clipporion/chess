# frozen_string_literal: true

require_relative 'node'
require_relative 'pieces'
require_relative 'setup'

# This is the class which will be used for the chess board.
# It consists of a hash containing all 64 nodes which represent the
# fields of the chess board.
# There is also a method to print the board to the command line.
class Board
  include Setup
  attr_reader :board

  def initialize
    @board = create_board
    fill_board
  end

  def create_board
    res = {}
    ('a'..'h').each do |row|
      (1..8).each do |line|
        res[[row, line]] = Node.new([row, line])
      end
    end
    res
  end

  def display
    print_letter_line
    print_lines
    print_letter_line
  end

  def print_lines
    print_separating_line
    line = 8
    while line.positive?
      print_line(line)
      line -= 1
    end
  end

  def print_line(line)
    print "#{line} "
    ('a'..'h').each do |letter|
      print "| #{@board[[letter, line]].piece.figure} "
    end
    print "| #{line}\n"
    print_separating_line
  end

  def print_letter_line
    print '  '
    ('a'..'h').each do |letter|
      print "  #{letter} "
    end
    puts
  end

  def print_separating_line
    print '  '
    8.times do
      print '+---'
    end
    print '+'
    puts
  end
end
