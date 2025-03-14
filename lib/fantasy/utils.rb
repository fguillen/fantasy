# frozen_string_literal: true

module Utils



  def self.collision_at?(actor, x, y)
    (
      actor.position.x < x &&
      (actor.position.x + actor.width) > x &&
      actor.position.y < y &&
      actor.position.y + actor.height > y
    )
  end

  def self.remap(value, from_ini:, from_end:, to_ini: 0, to_end: 1)
    to_ini + (value - from_ini) * (to_end - to_ini) / (from_end - from_ini)
  end
end
