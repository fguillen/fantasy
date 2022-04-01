# frozen_string_literal: true

module Utils
  # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
  # rubocop:disable Metrics/AbcSize
  def self.collision?(actor_1, actor_2)
    (
        actor_1.position.x < (actor_2.position.x + actor_2.width) &&
        (actor_1.position.x + actor_1.width) > actor_2.position.x &&
        actor_1.position.y < (actor_2.position.y + actor_2.height) &&
        actor_1.position.y + actor_1.height > actor_2.position.y
      )
  end
  # rubocop:enable Metrics/AbcSize


  def self.collision_at?(actor, x, y)
    (
      actor.position.x < x &&
      (actor.position.x + actor.width) > x &&
      actor.position.y < y &&
      actor.position.y + actor.height > y
    )
  end

  def self.remap(value:, from_ini:, from_end:, to_ini:, to_end:)
    to_ini + (value - from_ini) * (to_end - to_ini) / (from_end - from_ini)
  end
end
