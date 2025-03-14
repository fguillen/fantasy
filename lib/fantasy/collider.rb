class Collider
  include Log
  include Indexable

  attr_accessor :name,
                :position,
                :width,
                :height,
                :group,
                :solid,
                :collision_with,
                :active

  attr_reader :actor

  def initialize(actor:, position: Coordinates.zero, width: nil, height: nil, group: "all", name: nil, solid: false)
    @name = name
    @position = position
    @width = width || (actor.width / actor.scale)
    @height = height || (actor.height / actor.scale)
    @actor = actor
    @group = group
    @solid = solid
    @collision_with = "all"
    @on_collision_callback = nil
    @active = true

    actor.components.push(self)
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

  def position_in_world
    @position + actor.position
  end

  def width_in_world
    @width * actor.scale
  end

  def height_in_world
    @height * actor.scale
  end

  # rubocop:disable Metrics/AbcSize
  def collides_with?(other)
    # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    (
      position_in_world.x < (other.position_in_world.x + other.width_in_world) &&
      (position_in_world.x + width_in_world) > other.position_in_world.x &&
      position_in_world.y < (other.position_in_world.y + other.height_in_world) &&
      position_in_world.y + height_in_world > other.position_in_world.y
    )
  end
  # rubocop:enable Metrics/AbcSize


  # @!visibility private
  def draw
    draw_debug if Global.debug
  end

  def world_active
    @active && actor.active
  end

  def layer
    actor.layer
  end

  def position_in_camera
    actor.position_in_camera + @position
  end

  def on_collision_do(other)
    other_name = other.respond_to?(:name) ? other.name : "no-name"
    log("Collision detected with [#{other.object_id}] [#{other_name}]")
    actor.on_collision_do(self, other)
    @on_collision_callback&.call(other)
  end

  def solid?
    @solid
  end

  private

  def draw_debug
    Shape.rectangle(
      position: position_in_camera,
      width: width_in_world,
      height: height_in_world,
      fill: false,
      stroke_color: Color.palette.yellow,
      stroke: 1
    )

    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end
end
