class CollisionResolver
  extend Log
  def self.resolve_collisions
    collisionable_colliders.each do |collider|
      active_colliders.each do |other|
        if colliders_can_collide?(collider, other) && collider.collides_with?(other)
          collider.on_collision_do(other)
        end
      end
    end
  end

  def self.any_collision_down_with_solid?(collider)
    collider_down = collider.clone
    collider_down.position.y += 1

    result =
      active_colliders.select(&:solid).any? do |other|
        colliders_can_collide?(collider, other) && collider_down.collides_with?(other)
      end

    Log.ignore_log do
      collider_down.destroy
    end

    result
  end

  def self.movement_until_collision(collider, other, last_movement)
    return Coordinates.zero if last_movement.zero?

    collider_clone = collider.clone
    collider_clone.extract_from_parent
    collider_clone.position_in_world -= last_movement
    direction = last_movement.normalize
    x_blocked = direction.x.zero?
    y_blocked = direction.y.zero?
    loop do
      unless x_blocked
        collider_clone.position_in_world += Coordinates.new(direction.x, 0)
        if ( # rubocop:disable Style/RedundantParentheses
          !same_sign?(collider.position_in_world.x - collider_clone.position_in_world.x, direction.x) ||
          collider_clone.collides_with?(other)
        )
          x_blocked = true
          collider_clone.position_in_world -= Coordinates.new(direction.x, 0)
        end
      end

      break if x_blocked && y_blocked

      unless y_blocked
        collider_clone.position_in_world += Coordinates.new(0, direction.y)
        if ( # rubocop:disable Style/RedundantParentheses
          !same_sign?(collider.position_in_world.y - collider_clone.position_in_world.y, direction.y) ||
          collider_clone.collides_with?(other)
        )
          y_blocked = true
          collider_clone.position_in_world -= Coordinates.new(0, direction.y)
        end
      end

      break if x_blocked && y_blocked
    end

    max_movement = collider.position_in_world - collider_clone.position_in_world

    Log.ignore_log do
      collider_clone.destroy
    end

    max_movement
  end

  private

  def self.collisionable_colliders
    active_colliders.select do |collider|
      collider.collision_with != "none" &&
        collider.collision_with != [] &&
        !collider.collision_with.nil?
    end
  end

  def self.active_colliders
    Global.colliders.select do |collider|
      collider.active &&
        collider.parent.active
    end
  end

  def self.colliders_can_collide?(collider, other)
    return false if collider == other
    return false if collider.parent == other.parent
    return true if collider.collision_with == "all"
    return true if collider.collision_with.include?(other.group)

    false
  end

  def self.same_sign?(a, b)
    (a.positive? && b.positive?) || (a.negative? && b.negative?)
  end
end
