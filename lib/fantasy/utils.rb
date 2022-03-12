module Utils
  # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
  def self.collision?(actor_1, actor_2)
    result =
      (
        actor_1.position.x < (actor_2.position.x + actor_2.width) &&
        (actor_1.position.x + actor_1.width) > actor_2.position.x &&
        actor_1.position.y < (actor_2.position.y + actor_2.height) &&
        actor_1.position.y + actor_1.height > actor_2.position.y
      )

    result
  end

  def self.collision_at?(actor, x, y)
    (
      actor.position.x < x &&
      (actor.position.x + actor.width) > x &&
      actor.position.y < y &&
      actor.position.y + actor.height > y
    )
  end

  def self.draw_frame(x, y, width, height, stroke, color)
    Gosu.draw_rect(x, y, width, stroke, color)
    Gosu.draw_rect(x + (width - stroke), y, stroke, height, color)
    Gosu.draw_rect(x, y + (height - stroke), width, stroke, color)
    Gosu.draw_rect(x, y, stroke, height, color)
  end
end
