module Hud::Part
  attr_accessor :hud

  def active_in_world
    active && hud.active
  end

  def position_in_world
    result = position
    result *= hud.scale
    result += hud.position
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
