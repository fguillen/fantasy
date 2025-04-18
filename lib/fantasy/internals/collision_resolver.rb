class CollisionResolver
  def self.resolve_collisions
    collisionable_colliders_cached = collisionable_colliders

    collisionable_colliders_cached.each do |collider|
      collisionable_colliders_cached.each do |other|
        if colliders_collide?(collider, other)
          collider.on_collision_do(other)
        end
      end
    end
  end

  def self.any_collision_down_with_solid?(collider)
    collider_down = collider.duplicate
    collider_down.position.y += 1

    collisionable_colliders.select(&:solid).each do |other|
      if colliders_collide?(collider, other)
        return true
      end
    end

    collider_down.destroy
  end

  def self.collisionable_colliders
    Global.colliders.select do |collider|
      collider.active &&
        collider.actor.active &&
        collider.collision_with != "none" &&
        collider.collision_with != [] &&
        !collider.collision_with.nil?
    end
  end

  def self.colliders_collide?(collider, other)
    return false if collider == other
    return false if collider.actor == other.actor
    return true if collider.collision_with == "all"
    return true if collider.collision_with.include?(other.group)

    false
  end
end
