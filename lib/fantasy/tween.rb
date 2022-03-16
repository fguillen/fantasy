module Tween
  def self.move_towards(from:, to:, speed:)
    direction = to - from
    step = [direction.length, speed * Global.frame_time].min

    return to if step.zero?

    direction = direction.normalize
    return from + (direction * step)
  end
end
