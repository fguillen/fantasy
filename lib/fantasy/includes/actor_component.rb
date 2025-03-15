# Declares the ActorPart module,
# which is included in all components that are attached to an actor.
# This module provides methods to get the position, width, height,
# and layer of the component in the world and in the camera,
# based on the position, scale, and layer of the actor it is attached to.
module ActorPart
  def active_in_world
    active && actor.active
  end

  def position_in_world
    position + actor.position
  end

  def width_in_world
    result = width * actor.scale
    result *= scale if respond_to?(:scale)
    result
  end

  def height_in_world
    result = height * actor.scale
    result *= scale if respond_to?(:scale)
    result
  end

  def scale_in_world
    actor.scale * scale
  end

  def position_in_camera
    actor.position_in_camera + position
  end

  def rotation_in_world
    rotation + actor.rotation
  end

  def layer
    actor.layer
  end

  def actor
    @actor
  end
end
