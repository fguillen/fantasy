class Collider
  def initialize(position:, width:, height:, actor:, group:)
    @position = position
    @width = width
    @height = height
    @actor = actor
    @group = group
    @collision_with = "none"
    @on_collision_callback = nil
    @active = true
  end

  # Array of strings (or "all", or "none").
  # Represents with which other collider group this collider collides.
  #
  # Default `"none"`.
  #
  # @return [Array, String] the actual list of names of Colliders to collide with
  #
  # @example Set with which other Colliders this Collider is colliding:
  #   collider = Collider.new()
  #   collider.collision_with = ["enemy", "bullet"]
  #
  # @example Set this Colliders collides only with enemies
  #   collider = Collider.new()
  #   collider.collision_with = ["enemy"]
  #   # or using the shortcut:
  #   collider.collision_with = "enemy"
  #
  # @example Set this Colliders collides with all other Colliders
  #   collider = Collider.new()
  #   collider.collision_with = "all"
  #
  # @example Set this Colliders collides with none other Colliders
  #   collider = Collider.new()
  #   collider.collision_with = "none" # it is the default
  #
  def collision_with=(value)
    if value.is_a?(String) && value != "all" && value != "none"
      value = [value]
    end

    @collision_with = value
  end

  # The block to be executed when Actor collides with another Actor
  #
  # @example Collision detected with _"bullet"_
  #   actor = Actor.new("image")
  #   actor.on_collision do |other|
  #     if other.name == "bullet"
  #       actor.destroy
  #     end
  #   end
  def on_collision(&block)
    @on_collision_callback = block
  end

  private

  # This method is triggered when Actor collides with another Actor
  #
  # @example Limit Actor movement horizontally
  #   class Player < Actor
  #     def on_collision_do(other)
  #       if other.name == "bullet"
  #         destroy
  #       end
  #     end
  #   end
  def on_collision_do(other)
    instance_exec(other, &@on_collision_callback) unless @on_collision_callback.nil?
  end
end

# class CircleCollider
#   attr_accessor :x, :y, :radius

#   def initialize(x, y, radius)
#     @x = x
#     @y = y
#     @radius = radius
#   end

#   def collides_with?(other_collider)
#     distance = Math.sqrt((other_collider.x - @x)**2 + (other_collider.y - @y)**2)
#     distance < @radius + other_collider.radius
#   end

#   def on_collision(other_collider)
#     puts "Circle collided with circle"
#   end
# end

# class BoxCollider
#   attr_accessor :x, :y, :width, :height

#   def initialize(x, y, width, height)
#     @x = x
#     @y = y
#     @width = width
#     @height = height
#   end

#   def collides_with?(other_collider)
#     @x < other_collider.x + other_collider.width &&
#       @x + @width > other_collider.x &&
#       @y < other_collider.y + other_collider.height &&
#       @y + @height > other_collider.y
#   end

#   def on_collision(other_collider)
#     puts "Box collided with box"
#   end
# end

# collider = Collider.new
# collider.add_collider(CircleCollider.new(10, 10, 5))
# collider.add_collider(BoxCollider.new(10, 10, 5, 5))
# collider.check_collisions

# # Output:
# # Circle collided with circle
# # Box collided with box
# end
