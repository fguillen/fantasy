class Collider
  include Log
  include Indexable
  include ActorPart

  # When `true` the Collider won't go cross other `solid` Colliders.
  #
  # Default `false`.
  #
  # @return [Boolean] the actual solid value
  #
  # @param solid [true, false] only true or false
  #
  # @example Set solid
  #   collider = Collider.new()
  #   collider.solid = true
  attr_accessor :solid

  attr_accessor :name,
                :position,
                :width,
                :height,
                :group,
                :collision_with,
                :active

  def initialize(
    actor: nil,
    position: Coordinates.zero,
    width: nil,
    height: nil,
    group: "all",
    name: nil,
    solid: false
  )
    @name = name
    @position = position

    @width = width
    @width ||= (actor.width / actor.scale) if actor
    @width ||= 0
    @height = height
    @height ||= (actor.height / actor.scale) if actor
    @height ||= 0

    @actor = actor
    @group = group
    @solid = solid
    @collision_with = "all"
    @on_collision_callback = nil
    @active = true

    actor&.parts&.push(self)
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
    actor&.parts&.delete(self)
    Global.colliders.delete(self)
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

  def on_collision_do(other)
    other_name = other.respond_to?(:name) ? other.name : "no-name"
    log("Collision detected with [#{other.object_id}] [#{other_name}]")
    actor&.on_collision_do(self, other)
    @on_collision_callback&.call(other)
  end

  def solid?
    @solid
  end

  def clone
    new_collider =
      Collider.new(
        actor: @actor,
        position: @position.dup,
        width: @width,
        height: @height,
        group: @group,
        name: @name,
        solid: @solid
      )

    new_collider.collision_with = @collision_with

    new_collider
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
    ).draw

    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end
end
