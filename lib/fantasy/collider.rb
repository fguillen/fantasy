class Collider
  include Log
  include Indexable
  include Node

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
                :actor,
                :position,
                :width,
                :height,
                :group,
                :active

  attr_reader :physics_shape, :collision_with

  def initialize(
    actor:,
    position: Coordinates.zero,
    width: actor.width,
    height: actor.height,
    group: "all",
    collision_with: "all",
    name: "Collider_#{actor.name}",
    solid: false
  )
    @actor = actor

    @name = name
    @position = position

    @width = width
    @height = height

    @group = group
    @solid = solid
    @collision_with = collision_with
    @on_collision_callback = nil
    @active = true

    actor.add_child(self)
    Global.colliders&.push(self)

    @physics_shape = create_physics_shape
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
  def collision_with=(name_or_names)
    physics_shape.collision_with = name_or_names
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
    log("#destroy")
    actor.children&.delete(self)
    actor.physics_body.remove_collider(@physics_shape)
    Global.colliders.delete(self)
  end

  # rubocop:disable Metrics/AbcSize
  # def collides_with?(other)
  #   # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
  #   position_in_world.x < (other.position_in_world.x + other.width_in_world) &&
  #     (position_in_world.x + width_in_world) > other.position_in_world.x &&
  #     position_in_world.y < (other.position_in_world.y + other.height_in_world) &&
  #     position_in_world.y + height_in_world > other.position_in_world.y
  # end
  # rubocop:enable Metrics/AbcSize

  # @!visibility private
  def draw
    draw_debug if Global.debug
  end

  def on_collision_do(other_collider, contact)
    other_collider_name = other_collider.name
    log("Collision detected with [#{other_collider.object_id}] [#{other_collider_name}], on coordinates [#{contact[:coordinates]}]")
    actor.on_collision_do(self, other_collider, contact)
    @on_collision_callback&.call(other_collider, contact)
  end

  def on_collision_ends_do(other_collider, contact)
    log("Collision ends with [#{other_collider.object_id}] [#{other_collider.name}], on coordinates [#{contact[:coordinates]}]")
    actor.on_collision_ends_do(self, other_collider, contact)
  end

  def solid?
    @solid
  end

  def clone
    new_collider =
      Collider.new(
        actor: @actor,
        position: @position.clone,
        width: @width,
        height: @height,
        group: @group,
        name: @name,
        solid: @solid
      )

    new_collider.collision_with = @collision_with

    new_collider
  end

  def to_debug
    {
      id: object_id,
      name: @name,
      position: @position,
      width: @width,
      height: @height,
      group: @group,
      collision_with: @collision_with,
      solid: @solid,
      active: @active,
      actor: [@actor.object_id, @actor.name]
    }
  end

  def self.find_by_physics_shape_id_index(physics_shape_id_index)
    Global.colliders.find { |collider| collider.physics_shape.id.index1 == physics_shape_id_index }
  end

  def position_in_camera
    @actor.position_in_camera + @position
  end

  def width_in_world
    @width * Physics::World.pixels_per_meter
  end

  def height_in_world
    @height * Physics::World.pixels_per_meter
  end

  private

  def create_physics_shape
    actor.physics_body.add_collider(
      position: position,
      width: width,
      height: height,
      solid: solid,
      group: group,
      collision_with: collision_with
    )
  end

  def draw_debug
    Shape.rectangle(
      position: position_in_camera - Coordinates.new(width_in_world / 2, height_in_world / 2),
      width: width_in_world,
      height: height_in_world,
      fill: false,
      stroke_color: Color.palette.yellow,
      stroke: 1
    ).draw

    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end
end
