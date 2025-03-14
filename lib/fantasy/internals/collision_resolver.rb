class CollisionResolver
  def self.resolve_collisions
    collisionable_colliders.each do |collider|
      collisionable_colliders.each do |other|
        next if collider == other
        next if collider.actor == other.actor
        next if collider.collision_with.includes?(other.group) || collider.collision_with == "all"

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
      collider.collision_with != nil
    end
  end
end

# class CircleCollider
#   attr_accessor :x, :y, :radius
#
#   def initialize(x, y, radius)
#     @x = x
#     @y = y
#     @radius = radius
#   end
#
#   def collides_with?(other_collider)
#     distance = Math.sqrt((other_collider.x - @x)**2 + (other_collider.y - @y)**2)
#     distance < @radius + other_collider.radius
#   end
#
#   def on_collision(other_collider)
#     puts "Circle collided with circle"
#   end
# end
#
# class BoxCollider
#  attr_accessor :x, :y, :width, :height
#
#   def initialize(x, y, width, height)
#     @x = x
#     @y = y
#     @width = width
#     @height = height
#   end
#
#   def collides_with?(other_collider)
#     @x < other_collider.x + other_collider.width &&
#       @x + @width > other_collider.x &&
#       @y < other_collider.y + other_collider.height &&
#       @y + @height > other_collider.y
#   end
# end
#
# class Collider
#   include Log
#
#   attr_accessor :actor
#
#   def initialize(actor)
#     @actor = actor
#     Global.colliders << self
#   end
#
#   def collides_with?(other)
#     raise "Implement this method in the subclass"
#   end
#
#   def on_collision_do(other)
#     raise "Implement this method in the subclass"
#   end
#
#   def on_collision(&block)
#     @on_collision_callback = block
#   end
#
#   def destroy
#     Global.colliders.delete(self)
#   end
#
#   private
#
#   def on_collision_do(other)
#     other_name = other.respond_to?(:name) ? other.name : "no-name"
#     log("Collision detected with [#{other.object_id}] [#{other_name}]")
#     actor.on_collision_do(self, other)
#     @on_collision_callback&.call(other)
#   end
# end
#
# class CircleCollider < Collider
#   attr_accessor :x, :y, :radius
#
#   def initialize(actor, x, y, radius)
#     @x = x
#     @y = y
#     @radius = radius
#     super(actor)
#   end
#
#   def collides_with?(other_collider)
#     distance = Math.sqrt((other_collider.x - @x)**2 + (other_collider.y - @y)**2)
#     distance < @radius + other_collider.radius
#   end
#
#   def on_collision_do(other)
#     other_name = other
end
