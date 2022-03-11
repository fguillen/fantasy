class Camera
  attr_accessor :position

  def initialize(position: Coordinates.zero)
    @position = position
  end
end
