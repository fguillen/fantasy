# An element that is drawn on the screen.
# It has a position, relative to the Actor it is attached to.
# Some of the subclases are Sprite, Text, Animation, Shape, ... or you can do your own
# Just implement the draw method and you are good to go.
class Graphic
  include Indexable

  attr_accessor :name,
                :actor,
                :position,
                :active,
                :scale,
                :rotation,
                :flip

  def initialize(
    actor: nil,
    position: Coordinates.zero,
    name: nil
  )
    @name = name
    @position = position
    @active = true
    @actor = actor
    @scale = 1
    @rotation = 0
    @flip = "none"

    Global.graphics&.push(self)
  end

  def destroy
    actor&.parts&.delete(self)
    Global.graphics.delete(self)
  end

  def draw
    raise NotImplementedError, "You must implement the draw method"
  end
end
