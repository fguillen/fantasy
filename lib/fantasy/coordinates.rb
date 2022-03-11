require "vector2d"

class Coordinates < Vector2d
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

  def x=(value)
    @x = value
  end

  def y=(value)
    @y = value
  end
end