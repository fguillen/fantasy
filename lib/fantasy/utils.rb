# frozen_string_literal: true

module Utils
  def self.collision_at?(actor, x, y)
    (
      actor.position_in_world.x < x &&
      (actor.position_in_world.x + actor.width_in_world) > x &&
      actor.position_in_world.y < y &&
      actor.position_in_world.y + actor.height_in_world > y
    )
  end

  def self.remap(value, from_ini:, from_end:, to_ini: 0, to_end: 1)
    to_ini + (value - from_ini) * (to_end - to_ini) / (from_end - from_ini)
  end
end
