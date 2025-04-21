# Declares the ActorPart module,
# which is included in all components that are attached to an actor.
# This module provides methods to get the position, width, height,
# and layer of the component in the world and in the camera,
# based on the position, scale, and layer of the actor it is attached to.
module ActorPart
  attr_accessor :actor

  def active_in_world
    if actor
      active && actor.active
    else
      active
    end
  end

  def position_in_actor
    result = position.clone
    if actor
      if actor.flip == "horizontal"
        actor_width_center = actor.width / 2.to_f
        distant_to_center = actor_width_center - result.x
        result.x += distant_to_center + actor_width_center
        result.x -= width if respond_to?(:width)
      end
    end
    result
  end

  def position_in_world
    result = position_in_actor
    if actor
      result *= actor.scale
      result += actor.position_in_world
    end
    result.freeze
  end

  def position_in_world=(coordinates)
    if actor
      self.position = (coordinates - actor.position_in_world) / actor.scale
    else
      self.position = coordinates
    end
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
    position_in_world - Camera.main.position
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
end
