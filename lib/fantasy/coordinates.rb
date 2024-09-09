# frozen_string_literal: true

require "vector2d"

class Coordinates < Vector2d
  attr_writer :x, :y

  def self.zero
    Coordinates.new(0, 0)
  end

  def self.up
    Coordinates.new(0, -1)
  end

  def self.down
    Coordinates.new(0, 1)
  end

  def self.left
    Coordinates.new(-1, 0)
  end

  def self.right
    Coordinates.new(1, 0)
  end

  def clone
    Coordinates.new(@x, @y)
  end

  def zero?
    @x.zero? && @y.zero?
  end

  def direction(other)
    vector = other - self
    vector = vector.normalize
    Coordinates.from_vector(vector)
  end

  def self.from_vector(vector)
    Coordinates.new(vector.x, vector.y)
  end
end
