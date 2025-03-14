class CollisionResolver
  def self.resolve_collisions
    collisionable_colliders_cached = collisionable_colliders

    collisionable_colliders_cached.each do |collider|
      collisionable_colliders_cached.each do |other|
        next if collider == other
        next if collider.actor == other.actor
        next if !collider.collision_with == "all" && !collider.collision_with.includes?(other.group)

        if collider.collides_with?(other)
          collider.on_collision_do(other)
        end
      end
    end
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
end
