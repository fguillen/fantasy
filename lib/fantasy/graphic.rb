# An element that is drawn on the screen.
# It has a position, relative to the Actor it is attached to.
# Some of the subclases are Sprite, Text, Animation, Shape, ... or you can do your own
# Just implement the draw method and you are good to go.
class Graphic
  include Log
  include Indexable

  attr_accessor :name,
                :parent,
                :position,
                :active,
                :scale,
                :rotation,
                :flip

  def initialize(
    parent: nil,
    position: Coordinates.zero,
    name: nil
  )
    @name = name
    @position = position
    @active = true
    @parent = parent
    @scale = 1
    @rotation = 0
    @flip = "none"

    Global.graphics&.push(self)
  end

  def destroy
    log("#destroy")
    parent&.remove_child(self)
    Global.graphics.delete(self)
  end

  def width
    raise NotImplementedError, "You must implement the draw method"
  end

  def height
    raise NotImplementedError, "You must implement the draw method"
  end

  def draw
    raise NotImplementedError, "You must implement the draw method"
  end

  def draw_debug
    Shape.rectangle(
      position: position_in_camera,
      width: width,
      height: height,
      fill: false,
      stroke_color: Color.palette.pink,
      stroke: 1
    )
  end
end
