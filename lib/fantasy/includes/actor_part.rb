# Declares the ActorPart module,
# which is included in all components that are attached to an actor.
# This module provides methods to get the position, width, height,
# and layer of the component in the world and in the camera,
# based on the position, scale, and layer of the actor it is attached to.
module ActorPart
  def active_in_world
    if actor
      active && actor.active
    else
      active
    end
  end

  def position_in_world
    position + actor.position
  end

  def width_in_world
    result = width
    result *= actor.scale if actor
    result *= scale if respond_to?(:scale)
    result
  end

  def height_in_world
    result = height
    result *= actor.scale if actor
    result *= scale if respond_to?(:scale)
    result
  end

  def scale_in_world
    if actor
      scale * actor.scale
    else
      scale
    end
  end

  def position_in_camera
    if actor
      position + actor.position_in_camera
    else
      position
    end
  end

  def rotation_in_world
    if actor
      rotation + actor.rotation
    else
      rotation
    end
  end

  def layer
    if actor
      actor.layer
    else
      0
    end
  end

  def actor
    @actor
  end
end
