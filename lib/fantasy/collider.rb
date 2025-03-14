class Collider
  include Log

  def initialize(position:, width:, height:, actor:, group:, name: nil, solid: false)
    @name = name
    @position = position
    @width = width
    @height = height
    @actor = actor
    @group = group
    @solid = solid
    @collision_with = "all"
    @on_collision_callback = nil
    @active = true

    Global.colliders&.push(self)
  end

  # Array of strings (or "all", or "none").
  # Represents with which other collider group this collider collides.
  #
  # Default `"all"`.
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
  #   collider.collision_with = "all" # it is the default
  #
  # @example Set this Colliders collides with none other Colliders
  #   collider = Collider.new()
  #   collider.collision_with = "none"
  #
  def collision_with=(value)
    if value.is_a?(String) && value != "all" && value != "none"
      value = [value]
    end

    @collision_with = value
  end

  # The block to be executed when Collider collides with another Collider
  #
  # @example Collision detected with _"bullet"_
  #   collider.on_collision do |other|
  #     if other.name == "bullet"
  #       collider.actor.destroy
  #     end
  #   end
  def on_collision(&block)
    @on_collision_callback = block
  end

  # Destroy this Collider
  def destroy
    Global.colliders.delete(self)
  end

  def world_position
    @position + actor.position
  end

  def world_width
    @width * actor.scale.x
  end

  def world_height
    @height * actor.scale
  end

  # rubocop:disable Metrics/AbcSize
  def collides_with?(other)
    # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    (
      world_position.x < (other.world_position.x + other.world_width) &&
      (world_position.x + world_width) > other.world_position.x &&
      world_position.y < (other.world_position.y + other.world_heigh) &&
      world_position.y + world_heigh > other.world_position.y
    )
  end
  # rubocop:enable Metrics/AbcSize

  private

  def on_collision_do(other)
    other_name = other.respond_to?(:name) ? other.name : "no-name"
    log("Collision detected with [#{other.object_id}] [#{other_name}]")
    actor.on_collision_do(self, other)
    @on_collision_callback&.call(other)
  end
end
