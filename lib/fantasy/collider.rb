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
                :parent,
                :position,
                :width,
                :height,
                :group,
                :collision_with,
                :active

  def initialize(
    parent: nil,
    position: Coordinates.zero,
    width: nil,
    height: nil,
    group: "all",
    collision_with: "all",
    name: nil,
    solid: false
  )
    @name = name
    @position = position

    @width = width
    @width ||= parent.width if parent
    @width ||= 0
    @height = height
    @height ||= parent.height if parent
    @height ||= 0

    @parent = parent
    @group = group
    @solid = solid
    @collision_with = collision_with
    @on_collision_callback = nil
    @active = true

    parent&.add_child(self)
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
  #       collider.parent.destroy
  #     end
  #   end
  def on_collision(&block)
    @on_collision_callback = block
  end

  # Destroy this Collider
  def destroy
    log("#destroy")
    parent&.children&.delete(self)
    Global.colliders.delete(self)
  end

  # rubocop:disable Metrics/AbcSize
  def collides_with?(other)
    # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    position_in_world.x < (other.position_in_world.x + other.width_in_world) &&
      (position_in_world.x + width_in_world) > other.position_in_world.x &&
      position_in_world.y < (other.position_in_world.y + other.height_in_world) &&
      position_in_world.y + height_in_world > other.position_in_world.y
  end
  # rubocop:enable Metrics/AbcSize

  # @!visibility private
  def draw
    draw_debug if Global.debug
  end

  def on_collision_do(other)
    other_name = other.respond_to?(:name) ? other.name : "no-name"
    log("Collision detected with [#{other.object_id}] [#{other_name}]")
    parent&.on_collision_do(self, other)
    @on_collision_callback&.call(other)
  end

  def solid?
    @solid
  end

  def clone
    new_collider =
      Collider.new(
        parent: @parent,
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
      parent: [@parent.object_id, @parent.name]
    }
  end

  def extract_from_parent
    if @parent
      @position = position_in_world
      @width = width_in_world
      @height = height_in_world
      @parent.children.delete(self)
      @parent = nil
    end
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
