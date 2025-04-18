# frozen_string_literal: true

# Represents one active entity in the game.
# An actor can be the Player. Or one of the enemies. Or the bullet.
# An actor can also be a tree, or a wall
#
# @example Actor can be used directly
#   player = Actor.new("warrior") # ./images/warrior.png
#   player.position = Coordinates.new(100, 100)
#   player.speed = 200
#   player.layer = 1
#   player.move_with_cursors
#   player.collision_with = ["enemy", "bullets"] # default "none"
#
#   player.on_collision do |other|
#     if other.name == "enemy"
#       player.destroy
#     end
#   end
#
#   player.on_after_move do
#     if player.position.x > Global.screen_width
#       player.position.x = Global.screen_width
#     end
#
#     if player.position.x < 0
#       player.position.x = 0
#     end
#   end
#
# @example Or in a subclass:
#   class Player < Actor
#     def initialize
#       super("warrior") # ./images/warrior.png
#       @position = Coordinates.new(100, 100)
#       @speed = 200
#       @layer = 1
#       @direction = Coordinates.zero
#       @collision_with = ["enemy", "bullets"] # default "none"
#       move_with_cursors
#     end
#
#     on_collision do |other|
#       if other.name == "enemy"
#         destroy
#       end
#     end
#
#     on_after_move do
#       if @position.x > Global.screen_width
#         @position.x = Global.screen_width
#       end
#
#       if @position.x < 0
#         @position.x = 0
#       end
#     end
#   end
class Actor
  include Log
  include MoveByCursor
  include MoveByDirection
  include Mover
  include Gravitier
  include Jumper
  include UserInputs
  include Indexable

  attr_reader :is_on_floor

  # Coordinates object where x and y represent the position of the Actor in the World (no necessarily in the Screen).
  #
  # Default `Coordinates.zero`.
  #
  # @return [Coordinates] the actual position
  #
  # @example Setting position
  #   actor = Actor.new("image")
  #   actor.position = Coordinates.new(10, 20)
  #   actor.position.x # => 10
  #
  # @example Modify position
  #   actor.position.x +=  1
  #   actor.position.x # => 11
  attr_accessor :position

  # Controls the direction in which this Actor will move in the next frame.
  #
  # Default `Coordinates.zero`.
  #
  # @return [Coordinates] the actual direction
  #
  # @note The the pixels per second is represented by the `@speed` attribute
  #
  # @example Set direction
  #   actor = Actor.new("image")
  #   actor.direction = Coordinates.right
  attr_accessor :direction

  # Controls the pixels per second which this Actor will move in the next frame.
  #
  # Default `0`.
  #
  # @return [Float] the actual speed
  #
  # @note The the direction is represented by the `@direction` attribute
  #
  # @example Set speed
  #   actor = Actor.new("image")
  #   actor.speed = 10
  attr_accessor :speed

  # Controls impulse this Actor will receive when the (see #jump) is triggered.
  #
  # Default `0`.
  #
  # @return [Float] the actual jump_force
  #
  # @note The the direction will be `Coordinates.up`
  #
  # @example Set jump_force
  #   actor = Actor.new("image")
  #   actor.jump_force = 100
  attr_accessor :jump_force

  # Controls constant force this Actor will receive on each frame.
  #
  # Default `0`.
  #
  # @return [Float] the actual gravity
  #
  # @note The the direction will be `Coordinates.down`
  #
  # @example Set gravity
  #   actor = Actor.new("image")
  #   actor.gravity = 10
  attr_accessor :gravity

  # @!visibility private
  attr_reader :parts

  # The value to scale the image of the Actor when drawn.
  # If the value is `2` the image will rendered at double of size.
  # If the value is `0.5` the image will rendered at half of size.
  #
  # @note this value affects the attributes `width` and `height`
  #
  # Default `1`.
  #
  # @return [Float] the actual scale
  #
  # @example Set scale
  #   actor = Actor.new("image")
  #   actor.scale = 6
  attr_accessor :scale

  # The the angle to rotate the image of the Actor when drawn (in degrees).
  # If the value is `90` the image will rendered rotated 1 quarter of circle in clockwise direction.
  # If the value is `-90` the image will rendered rotated 1 quarter of circle in counterclockwise direction.
  # If the value is `180` the image will rendered rotated and rendered heads down.
  #
  # @note Collisions will be calculated based on the rotation = 0
  #
  # Default `0`.
  #
  # @return [Float] the rotation in degrees
  #
  # @example Set image heads down
  #   actor = Actor.new("image")
  #   actor.rotation = 180
  attr_accessor :rotation

  # The actual value of the image flip
  attr_reader :flip

  # The value of the internal name of this Actor.
  #
  # It is useful for collision management for example.
  #
  # Default (taken from the constructor parameter).
  #
  # @return [String] the actual name
  #
  # @example Set name
  #   actor = Actor.new("image")
  #   actor.name = "spaceship"
  #
  # @example Used in collision trigger
  #   actor = Actor.new("image")
  #   actor.on_collision do |other|
  #     if other.name == "enemy"
  #       # damage
  #     end
  #   end
  #
  # @example Used with `collision_with`
  #   actor = Actor.new("image")
  #   actor.collision_with = ["enemy", "bullet"]
  attr_accessor :name

  # In which layer the image of the Actor is rendered.
  # Smaller numbers are rendered behind higher numbers.
  #
  # Default `0`.
  #
  # @return [Integer] the actual layer
  #
  # @example Set layer
  #   actor = Actor.new("image")
  #   actor.layer = -1
  attr_accessor :layer

  # Returns the list of collection of objects
  # that the Actor collided with.
  #
  # Default 'none'.
  attr_reader :collision_with

  # Represents the visibility of the image.
  #
  # Default `true`.
  #
  # @return [bool] the actual value of `active`
  #
  # @example Make an Actor no active
  #   actor = Actor.new("image")
  #   actor.active = false
  #
  attr_accessor :active

  # TODO: Change the name, I don't like to say `kill``
  # When active the Actor will be removed when
  # it is outside of the screen (by 100 pixels).
  #
  # When an Actor is autokilled, the on_destroy method will NOT be called.
  #
  # Default `true`.
  #
  # @return [bool] the actual value of `autokill`
  #
  # @example Make an Actor to not autokill when out of the screen
  #   actor = Actor.new("image")
  #   actor.autokill = false
  #
  attr_accessor :autokill

  attr_reader :pocket

  # Generate an Actor with all the default attribute values
  # @example Generate an Actor
  #   actor = Actor.new("image")
  #   actor.position # => Coordinates.zero
  #   actor.direction # => Coordinates.zero
  #   actor.speed # => 0
  #   actor.scale # => 1
  #   actor.rotation # => 0
  #   actor.flip # => "none"
  #   actor.autokill # => "true"
  #   actor.draggable_on_debug # => true
  #   actor.layer # => 0
  #   actor.gravity # => 0
  #   actor.jump_force # => 0
  #   actor.collision_with # => "none"
  #   actor.name # => "image"
  #
  # @example Generate an Actor from an animation
  #   animation = Animation.new(images: ["image1", "image2", "image3"])
  #   actor = Actor.new(animation)
  #
  # @param image_name_or_image_or_animation [string | Image | Animation] the name of the image file from `./images/*`. Or an Image object. Or an Animation object
  # @return [Actor] the Actor
  def initialize(name: nil, graphic: nil)
    @parts = []

    @graphic = nil
    self.graphic = graphic if graphic

    @name = name
    @name ||= graphic&.name if graphic.respond_to?(:name)
    @name ||= graphic if graphic.is_a?(String)

    @position = Coordinates.zero
    @direction = Coordinates.zero
    @last_frame_position = @position.clone
    @speed = 0
    @scale = 1
    @rotation = 0
    @flip = "none" # "horizontal" or "vertical" or "none" or "both"
    @active = true
    @autokill = true

    @draggable_on_debug = true
    @dragging = false
    @dragging_offset = nil
    @layer = 0
    @gravity = 0
    @jump_force = 100

    @is_on_floor = false

    @on_after_move_callback = nil
    @on_destroy_callback = nil
    @on_jumping_callback = nil
    @on_collision_callback = nil
    @is_on_floor_callback = nil

    @states = {}
    @state = nil

    @pocket = {}

    Global.actors&.push(self)
  end

  # Set a new graphical represenation of the Actor.
  # @param image_name_or_image_or_animation [String|Image|Animation] The image file from `./images.(png|jpg|jpeg)`. Or an Image. Or an Animation
  #
  # @example Set a new image by name
  #   actor = Actor.new("player_walk")
  #   actor.graphic = "player_jump"
  #
  # @example Set a new image
  #   image = Image.new("player_idle")
  #   actor = Actor.new("player_walk")
  #   actor.graphic = image
  #
  # @example Set a new animation
  #   animation = Animation.new(names: ["apple_1", "apple_2"])
  #   actor = Actor.new("player_walk")
  #   actor.graphic = animation
  def graphic=(image_name_or_image_or_animation)
    @graphic =
      if image_name_or_image_or_animation.is_a?(Animation)
        image_name_or_image_or_animation
      elsif image_name_or_image_or_animation.is_a?(Sprite)
        image_name_or_image_or_animation
      else
        Sprite.new(image_name_or_image_or_animation)
      end

    @graphic.actor = self

    previous_graphics = @parts.select { |component| component.is_a?(Graphic) }
    previous_graphics.each(&:destroy)
    @parts.push(@graphic)
  end

  # Configure the flip of the image.
  # Default `"none"`.
  #
  # @param value [String] "horizontal" or "vertical" or "none" or "both"
  #
  # @example Set flip horizontal
  #   actor = Actor.new("player_walk")
  #   actor.flip = "horizontal"
  # @example Set flip vertical
  #   actor = Actor.new("player_walk")
  #   actor.flip = "vertical"
  # @example Unset any flip
  #   actor = Actor.new("player_walk")
  #   actor.flip = "none"
  # @example Set flip in both coordinates horizontal and vertical
  #   actor = Actor.new("player_walk")
  #   actor.flip = "both"
  def flip=(value)
    valid_values = %w[horizontal vertical none both]
    unless valid_values.include?(value)
      raise ArgumentError, "The value must be one of: #{valid_values.join(", ")}"
    end

    @flip = value
  end

  # @return [Fixnum] the Actor width in pixels
  def width
    if @graphic
      @graphic.width_in_world
    else
      0
    end
  end

  # @return [Fixnum] the Actor height in pixels
  def height
    if @graphic
      @graphic.height_in_world
    else
      0
    end
  end

  # @param value [Coordinates] set a new direction to the Actor.
  # The vector is normalized
  #
  # @example Set a new direction
  #   actor = Actor.new("player_walking")
  #   actor.direction = Coordinates.up
  def direction=(value)
    @direction = value
    @direction = @direction.normalize unless @direction.zero?
  end

  # Configure a specific behavior on a state of the Actor
  #
  # @param value [Symbol] The name of the state to be configured
  #
  # @example Set a behavior on the Actor when it is walking
  #   actor = Actor.new("player")
  #   actor.on_state(:walking) do
  #     puts "I'm walking"
  #   end
  #
  # @example Change the image of the Actor when it is walking
  #   image = Image.new("player_walk")
  #   actor = Actor.new("player")
  #   actor.on_state(:walking) do
  #     actor.graphic = image
  #   end
  def on_state(state_name, &block)
    @states[state_name.to_sym] = block
  end

  # Activate a state on the Actor
  #
  # @param value [Symbol] The name of the state to be activated
  #
  # @example Activate the state 'walking'
  #   actor = Actor.new("player")
  #   actor.state(:walking)
  def state(state_name)
    state_name = state_name.to_sym

    if @states[state_name].nil?
      raise ArgumentError, "The state '#{state_name}' has not been defined. Available states: '#{@states.keys.join(", ")}'"
    end

    @states[state_name].call
    @state = state_name
  end

  # @!visibility private
  def draw
    @graphic&.draw
    draw_debug if Global.debug
  end

  # @!visibility private
  def move
    mouse_position = Global.mouse_position + Camera.main.position

    if @draggable_on_debug && Global.debug && !@dragging && Gosu.button_down?(Gosu::MS_LEFT) && Utils.collision_at?(self, mouse_position.x, mouse_position.y)
      @dragging = true
      @dragging_offset = mouse_position - @position
    end

    if @dragging && !Gosu.button_down?(Gosu::MS_LEFT)
      @dragging = false
    end

    if @dragging
      @position = mouse_position - @dragging_offset
    else
      # Cursors moving
      @last_frame_position = @position.clone
      move_by_cursors

      # Direction moving
      unless @direction.zero?
        @last_frame_position = @position.clone
        move_by_direction
      end

      # Gravity force
      unless @gravity.zero?
        add_force_by_gravity
      end

      # Apply forces
      apply_forces
    end

    checking_autokill if @autokill
    on_after_move_do
  end

  # Destroy this Actor is not longer, moved, or rendered
  #
  # @example Destroy an Actor
  #   actor = Actor.new("image")
  #   actor.destroy
  def destroy
    on_destroy_do
    parts.each(&:destroy)
    Global.actors.delete(self)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  # @!visibility private
  def clone
    actor = self.class.new
    actor.name = @name
    actor.position = @position.clone
    actor.last_frame_position = @position.clone
    actor.direction = @direction.clone

    # actot.parts = @parts.clone # TODO: Fix this

    actor.speed = @speed
    actor.scale = @scale
    actor.layer = @layer
    actor.gravity = @gravity
    actor.jump_force = @jump_force
    actor.autokill = @autokill
    actor.colliders = @colliders.clone

    actor.on_after_move_callback = @on_after_move_callback
    actor.on_destroy_callback = @on_destroy_callback
    actor.on_jumping_callback = @on_jumping_callback
    actor.on_collision_callback = @on_collision_callback
    actor.on_floor_callback = @is_on_floor_callback

    actor.on_cursor_down_callback = @on_cursor_down_callback
    actor.on_cursor_up_callback = @on_cursor_up_callback
    actor.on_cursor_left_callback = @on_cursor_left_callback
    actor.on_cursor_right_callback = @on_cursor_right_callback
    actor.on_space_bar_callback = @on_space_bar_callback
    actor.on_key_callbacks = @on_key_callbacks.clone
    actor.on_mouse_button_left_callback = @on_mouse_button_left_callback

    actor.on_click_callback = @on_click_callback

    actor
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # Set callbacks

  # The block to be executed after each frame
  #
  # @example Limit Actor movement horizontally
  #   actor = Actor.new("image")
  #   actor.on_after_move do
  #     if actor.position.x > 100
  #       actor.position.x = 100
  #     end
  #   end
  def on_after_move(&block)
    @on_after_move_callback = block
  end

  # The block to be executed before the Actor is destroyed
  #
  # @example Executes when destroyed
  #   actor = Actor.new("image")
  #   actor.on_destroy do
  #     Sound.play("explosion")
  #   end
  def on_destroy(&block)
    @on_destroy_callback = block
  end

  # The block to be executed when the Actor starts jumping
  #
  # @example Change image when jumping
  #   actor = Actor.new("walk")
  #   actor.on_jumping do
  #     actor.graphic = "jump"
  #   end
  def on_jumping(&block)
    @on_jumping_callback = block
  end

  # The block to be executed when the Actor touches floor
  #
  # @example Change image when jumping
  #   actor = Actor.new("walk")
  #   actor.on_floor do
  #     actor.graphic = "land"
  #     Clock.new { actor.graphic = "walk" }.run_on(seconds: 0.8)
  #   end
  def on_floor(&block)
    @is_on_floor_callback = block
  end

  # !visibility private
  def position_in_camera
    @position - Camera.main.position
  end

  # !visibility private
  def on_collision_do(self_collider, other_collider)
    if self_collider.solid? && other_collider.solid?
      collision_with_solid(other_collider)
    end

    do_on_collision(other_collider.actor)
    instance_exec(&@on_collision_callback) unless @on_collision_callback.nil?
  end

  def add_part(part)
    @parts.push(part)
    part.actor = self
  end

  def remove_part(part)
    @parts.delete(part)
    part.actor = nil
  end

  # protected

  def do_after_move
    # To be overriden
  end

  def do_on_collision(other)
    # To be overriden
  end

  private

  # Execute callbacks
  def on_after_move_do
    do_after_move
    instance_exec(&@on_after_move_callback) unless @on_after_move_callback.nil?
  end

  def on_destroy_do
    instance_exec(&@on_destroy_callback) unless @on_destroy_callback.nil?
  end

  def on_jumping_do
    instance_exec(&@on_jumping_callback) unless @on_jumping_callback.nil?
  end

  def on_floor_do
    instance_exec(&@is_on_floor_callback) unless @is_on_floor_callback.nil?
  end

  def to_s
    "Actor (#{object_id}): #{name} (#{position.x},#{position.y})"
  end

  def draw_debug
    @parts.each do |part|
      part.draw_debug if part.respond_to?(:draw_debug)
    end

    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end

  def collision_with_solid(other_collider)
    @velocity ||= Coordinates.zero # In case it is not initialized yet

    # Collision with the floor
    if other_collider.position_in_world.y >= @last_frame_position.y
      on_floor_do unless @is_on_floor

      @is_on_floor = true
      @jumping = false
      @velocity.y = 0
    end

    # Collision with the ceiling
    if other_collider.position_in_world.y + other_collider.height_in_world <= @last_frame_position.y
      @velocity.y = 0
    end

    @position = @last_frame_position.clone
  end

  # If actor is out of the screen by 100 pixels, destroy it
  def checking_autokill
    margin_pixels = 100

    if position_in_camera.x < -margin_pixels ||
       position_in_camera.x > Global.screen_width + margin_pixels ||
       position_in_camera.y < -margin_pixels ||
       position_in_camera.y > Global.screen_height + margin_pixels

      log "Autokill: #{name}"
      Global.actors.delete(self)
    end
  end

  attr_accessor :on_after_move_callback,
                :on_collision_callback,
                :on_destroy_callback,
                :on_jumping_callback,
                :on_floor_callback
end
