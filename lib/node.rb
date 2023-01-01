# frozen_string_literal: true

require_relative 'pieces'
# This class is representing the fields on the chess board.
# It contains a variable to store a chess piece if one is placed on the field
class Node
  attr_accessor :piece, :location

  def initialize(location)
    @location = location
    @piece = Empty.new(@location)
  end
end
