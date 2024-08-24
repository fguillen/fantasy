# frozen_string_literal: true

# Represents one active entity in the game.
# An actor can be the Player sprite. Or one of the enemies. Or the bullet.
# An actor can also be a tree, or a wall
#
# @example Actor can be used directly
#   player = Actor.new("warrior") # ./images/warrior.png
#   player.position = Coordinates.new(100, 100)
#   player.solid = true
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
#       @solid = true
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

  # When `true` the Actor will cause and respond to collisions.
  #
  # When `false` the Actor won't cause neither respond to collisions.
  #
  # Default `true`.
  #
  # @return [Boolean] the actual solid value
  #
  # @param solid [true, false] only true or false
  #
  # @example Set solid
  #   actor = Actor.new("image")
  #   actor.solid = false
  attr_accessor :solid

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

  # Array of strings (or "all", or "none").
  # Represents with which other solid Actors this Actor collide.
  #
  # Default `"none"`.
  #
  # @return [Array, String] the actual list of names of Actors to collide with
  #
  # @example Set with which other Actors this Actor is colliding:
  #   actor = Actor.new("image")
  #   actor.collision_with = ["enemy", "bullet"]
  #
  # @example Set this Actors collides only with enemies
  #   actor = Actor.new("image")
  #   actor.collision_with = ["enemy"]
  #   # or using the shortcut:
  #   actor.collision_with = "enemy"
  #
  # @example Set this Actors collides with all other Actors
  #   actor = Actor.new("image")
  #   actor.collision_with = "all"
  #
  # @example Set this Actors collides with none other Actors
  #   actor = Actor.new("image")
  #   actor.collision_with = "none" # it is the default
  #
  attr_accessor :collision_with

  # Represents the visibility of the image.
  #
  # Default `true`.
  #
  # @return [bool] the actual value of `visible`
  #
  # @example Make an Actor no visible
  #   actor = Actor.new("image")
  #   actor.visible = false
  #
  attr_accessor :visible

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

  # Generate an Actor with all the default attribute values
  # @example Generate an Actor
  #   actor = Actor.new("image")
  #   actor.position # => Coordinates.zero
  #   actor.direction # => Coordinates.zero
  #   actor.speed # => 0
  #   actor.scale # => 1
  #   actor.solid # => true
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
  # @param image_name_or_image_or_animation [string | Image | Animation] the name of the image file from `./images/*`. Or an Image object. Or an Animation object
  # @return [Actor] the Actor
  def initialize(image_name_or_image_or_animation)
    self.sprite = image_name_or_image_or_animation

    @name =
      if image_name_or_image_or_animation.is_a?(Animation)
        image_name_or_image_or_animation.name
      elsif image_name_or_image_or_animation.is_a?(String)
        image_name_or_image_or_animation
      else
        nil
      end

    @position = Coordinates.zero
    @direction = Coordinates.zero
    @speed = 0
    @scale = 1
    @rotation = 0
    @flip = "none" # "horizontal" or "vertical" or "none" or "both"
    @visible = true
    @autokill = true

    @solid = true
    @draggable_on_debug = true
    @dragging = false
    @dragging_offset = nil
    @layer = 0
    @gravity = 0
    @jump_force = 0
    @collision_with = "none"

    @on_floor = false

    @on_after_move_callback = nil
    @on_collision_callback = nil
    @on_destroy_callback = nil
    @on_jumping_callback = nil
    @on_floor_callback = nil

    Global.actors&.push(self)
  end

  # Set a new graphical represenation of the Actor.
  # @param image_name_or_animation [String|Animation] The image file from `./images.(png|jpg|jpeg)`. Or an Animation
  #
  # @example Set a new image
  #   actor = Actor.new("player_walk")
  #   actor.sprite = "player_jump"
  #
  # @example Set a new animation
  #   animation = Animation.new(names: ["apple_1", "apple_2"])
  #   actor = Actor.new("player_walk")
  #   actor.sprite = animation
  def sprite=(image_name_or_image_or_animation)
    if image_name_or_image_or_animation.is_a?(Animation)
      @sprite = image_name_or_image_or_animation
    elsif image_name_or_image_or_animation.is_a?(Image)
      @sprite = image_name_or_image_or_animation
    else
      @sprite = Image.new(image_name_or_image_or_animation)
    end
  end

  def collision_with=(value)
    if value.is_a?(String) && value != "all" && value != "none"
      value = [value]
    end

    @collision_with = value
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
  def flip(value)
    valid_values = ["horizontal", "vertical", "none", "both"]
    if !valid_values.include?(value)
      raise ArgumentError, "The value must be one of: #{valid_values.join(", ")}"
    end

    puts "Set flip to: #{value}"

    @flip = value
  end

  # @return [Fixnum] the Actor width in pixels
  def width
    @sprite.width * @scale
  end

  # @return [Fixnum] the Actor height in pixels
  def height
    @sprite.height * @scale
  end

  # @return [Boolean] the value of `@solid`
  def solid?
    @solid
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

  # @!visibility private
  def draw
    @sprite.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale, rotation: @rotation, flip: @flip)

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
      last_position = @position
      move_by_cursors

      # Direction moving
      unless @direction.zero?
        last_position = @position
        move_by_direction
      end

      # Gravity force
      unless @gravity.zero?
        add_force_by_gravity
      end

      # Apply forces
      apply_forces

      # Check collisions after moving
      if @solid
        manage_collisions(last_position)
      end
    end

    checking_autokill if @autokill
    on_after_move_do
  end

  # Destroy this Actor is not longer, moved, or rendered, or cause any collision.
  #
  # @example Destroy an Actor
  #   actor = Actor.new("image")
  #   actor.destroy
  def destroy
    on_destroy_do
    Global.actors.delete(self)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  # @!visibility private
  def clone
    actor = self.class.new(@sprite)
    actor.name = @name
    actor.position = @position.clone
    actor.direction = @direction.clone

    actor.speed = @speed
    actor.scale = @scale
    actor.solid = @solid
    actor.layer = @layer
    actor.gravity = @gravity
    actor.jump_force = @jump_force
    actor.collision_with = @collision_with
    actor.autokill = @autokill

    actor.on_after_move_callback = @on_after_move_callback
    actor.on_collision_callback = @on_collision_callback
    actor.on_destroy_callback = @on_destroy_callback
    actor.on_jumping_callback = @on_jumping_callback
    actor.on_floor_callback = @on_floor_callback

    actor.on_cursor_down_callback = @on_cursor_down_callback
    actor.on_cursor_up_callback = @on_cursor_up_callback
    actor.on_cursor_left_callback = @on_cursor_left_callback
    actor.on_cursor_right_callback = @on_cursor_right_callback
    actor.on_space_bar_callback = @on_space_bar_callback
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
  #     actor.sprite = "jump"
  #   end
  def on_jumping(&block)
    @on_jumping_callback = block
  end

  # The block to be executed when the Actor touches floor
  #
  # @example Change image when jumping
  #   actor = Actor.new("walk")
  #   actor.on_floor do
  #     actor.sprite = "land"
  #     Clock.new { actor.sprite = "walk" }.run_on(seconds: 0.8)
  #   end
  def on_floor(&block)
    @on_floor_callback = block
  end

  # Execute callbacks

  # This method is triggered after each frame
  #
  # @example Limit Actor movement horizontally
  #   class Player < Actor
  #     def on_after_move_do
  #       if @position.x > 100
  #         @position.x = 100
  #       end
  #     end
  #   end
  def on_after_move_do
    instance_exec(&@on_after_move_callback) unless @on_after_move_callback.nil?
  end

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

  # This method is triggered before the Actor is destroyed
  #
  # @example Executes when destroyed
  #   class Player < Actor
  #     def on_destroy_do
  #       Sound.play("explosion")
  #     end
  #   end
  def on_destroy_do
    instance_exec(&@on_destroy_callback) unless @on_destroy_callback.nil?
  end

  # This method is triggered when the Actor starts jumping
  #
  # @example Change image when jumping
  #   class Player < Actor
  #     def on_jumping_do
  #       self.sprite = "jump"
  #     end
  #   end
  def on_jumping_do
    instance_exec(&@on_jumping_callback) unless @on_jumping_callback.nil?
  end

  # This method is triggered when the Actor touches floor
  #
  # @example Change image when jumping
  #   class Player < Actor
  #     def.on_floor_do
  #       self.sprite = "land"
  #       Clock.new { self.sprite = "walk" }.run_on(seconds: 0.8)
  #     end
  #   end
  def on_floor_do
    instance_exec(&@on_floor_callback) unless @on_floor_callback.nil?
  end

  def to_s
    "Actor (#{object_id}): #{name} (#{position.x},#{position.y})"
  end

  protected

  # TODO: make this work optimized
  # def position_top_left
  #   @position - position_delta
  # end

  # def position_delta
  #   case @alignment
  #   when "top-left"
  #     Coordinates.zero
  #   when "center"
  #     Coordinates.new(width/2, height/2)
  #   else
  #     raise "Actor.alignment value not valid '#{@alignment}'. Valid values: 'top-left, center'"
  #   end
  # end

  def draw_debug
    if solid
      Shape.rectangle(
        position: position_in_camera,
        width: width,
        height: height,
        fill: false,
        stroke_color: Color.palette.red,
        stroke: 1
      )
    end

    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end

  def position_in_camera
    @position - Camera.main.position
  end

  def manage_collisions(last_position)
    @velocity ||= Coordinates.zero # In case it is not initialized yet

    collisions.each do |other|
      on_collision_do(other)
      other.on_collision_do(self)

      if other.position.y >= (last_position.y + height)
        on_floor_do unless @on_floor

        @on_floor = true
        @jumping = false
        @velocity.y = 0
      end

      if other.position.y + other.height <= last_position.y
        @velocity.y = 0
      end
    end

    # # Reset position pixel by pixel
    # was_collision = false
    # while collisions.any? && @position != last_position
    #   was_collision = true
    #   last_position_direction = last_position - @position
    #   @position += last_position_direction.normalize
    # end
    # was_collision

    if collisions.any? # we don't cache collisions because position may be changed on collision callback
      @position = last_position

      return true
    end

    false
  end

  # rubocop:disable Style/Next
  def collisions
    return [] if @collision_with == "none"

    Global.actors.reject { |e| e == self }.select(&:solid?).select do |other|
      if (@collision_with == "all" || @collision_with.include?(other.name))
        Utils.collision? self, other
      end
    end
  end
  # rubocop:enable Style/Next

  # If actor is out of the screen by 100 pixels, destroy it
  def checking_autokill
    margin_pixels = 100

    if(
      position_in_camera.x < -margin_pixels ||
      position_in_camera.x > Global.screen_width + margin_pixels ||
      position_in_camera.y < -margin_pixels ||
      position_in_camera.y > Global.screen_height + margin_pixels
    )
      puts ">>>> Autokill: #{self.name}"
      Global.actors.delete(self)
    end
  end

  attr_accessor :on_after_move_callback, :on_collision_callback, :on_destroy_callback, :on_jumping_callback, :on_floor_callback
  attr_accessor :on_click_callback
end
