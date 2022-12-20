# frozen_string_literal: true

# This class is representing the fields on the chess board.
# It contains a variable to store a chess piece if one is placed on the field
# and also knows all of the available neighbor nodes
class Node
  attr_reader :location, :left, :left_down, :left_up,
              :up, :down, :right, :right_down, :right_up
  attr_accessor :piece

  def initialize(location)
    @location = location
    @piece = ' '
    @left_up = set_neighbor(location, [-1, 1])
    @up = set_neighbor(location, [0, 1])
    @right_up = set_neighbor(location, [1, 1])
    @left = set_neighbor(location, [-1, 0])
    @right = set_neighbor(location, [1, 0])
    @left_down = set_neighbor(location, [-1, -1])
    @down = set_neighbor(location, [0, -1])
    @right_down = set_neighbor(location, [-1, 1])
  end

  def set_neighbor(location, move)
    x = (location[0].ord + move[0]).chr
    y = location[1] + move[1]
    ('a'..'h').include?(x) && (1..8).include?(y) ? [x, y] : nil
  end
end
