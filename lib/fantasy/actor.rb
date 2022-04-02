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
#   player.collision_with = ["enemy", "bullets"] # default "all"
#
#   player.on_collision do |other|
#     if other.name == "enemy"
#       player.destroy
#     end
#   end
#
#   player.on_after_move do
#     if player.position.x > SCREEN_WIDTH
#       player.position.x = SCREEN_WIDTH
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
#       @collision_with = ["enemy", "bullets"] # default "all"
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
#       if @position.x > SCREEN_WIDTH
#         @position.x = SCREEN_WIDTH
#       end
#
#       if @position.x < 0
#         @position.x = 0
#       end
#     end
#   end
class Actor
  include MoveByCursor
  include MoveByDirection
  include Mover
  include Gravitier
  include Jumper
  include UserInputs

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

  # The value to internal name of this Actor.
  #
  # It is useful for collision management for example.
  #
  # Default (same as `image_name`).
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

  # Array of strings (or "all").
  # Represents with which other solid Actors this Actor collide.
  #
  # Default `"all"`.
  #
  # @return [Array, String] the actual list of names of Actors to collide with
  #
  # @example Set with which other Actors this Actor is colliding:
  #   actor = Actor.new("image")
  #   actor.collision_with = ["enemy", "bullet"]
  #
  # @example Set this Actors collides with all other Actors
  #   actor = Actor.new("image")
  #   actor.collision_with = "all"
  attr_accessor :collision_with

  # Generate an Actor with all the default attribute values
  # @example Generate an Actor
  #   actor = Actor.new("image")
  #   actor.position # => Coordinates.zero
  #   actor.direction # => Coordinates.zero
  #   actor.speed # => 0
  #   actor.scale # => 1
  #   actor.solid # => true
  #   actor.draggable_on_debug # => true
  #   actor.layer # => 0
  #   actor.gravity # => 0
  #   actor.jump_force # => 0
  #   actor.collision_with # => "all"
  #
  # @param image_name [string] the name of the image file from `./images/*`
  # @return [Actor] the Actor
  def initialize(image_name)
    @image_name = image_name
    @image = Image.new(image_name)
    @name = image_name
    @position = Coordinates.zero
    @direction = Coordinates.zero
    @speed = 0
    @scale = 1

    @solid = false
    @draggable_on_debug = true
    @dragging = false
    @dragging_offset = nil
    @layer = 0
    @gravity = 0
    @jump_force = 0
    @collision_with = "all"

    @on_floor = false

    @on_after_move_callback = nil
    @on_collision_callback = nil
    @on_destroy_callback = nil
    @on_jumping_callback = nil
    @on_floor_callback = nil

    Global.actors << self
  end


  # Set a new image to the Actor.
  # @param image_name [String] The image file from `./images/*`
  #
  # @example Set a new image
  #   actor = Actor.new("player_walk")
  #   actor.image_name = "player_jump"
  def image=(image_name)
    @image = Image.new(image_name)
  end

  # @return [Fixnum] the Actor width in pixels
  def width
    @image.width * @scale
  end

  # @return [Fixnum] the Actor height in pixels
  def height
    @image.height * @scale
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
    @image.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale)

    draw_debug if Global.debug
  end

  # @!visibility private
  # TODO: I made more of this code while I was with Covid
  # It looks horrible and it is crap
  # I'll improve it some day :)
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
      # Direction moving
      unless @direction.zero?
        last_position = @position
        move_by_direction

        # Check collision after cursor moving
        if @solid && @position != last_position
          manage_collisions(last_position)
        end
      end

      # Cursors moving
      last_position = @position
      move_by_cursors

      # Check collision after cursor moving
      if @solid && @position != last_position
        manage_collisions(last_position)
      end

      # # Jump moving
      # unless @jump_force.zero?
      #   last_position = @position
      #   add_force_by_jump
      #   apply_forces(max_speed: @jump_speed || @jump_force)

      #   # Check collision after jump moving
      #   if @solid && @position != last_position
      #    if manage_collisions(last_position)
      #       @jumping = false
      #    end
      #   end
      # end

      # Gravity force
      unless @gravity.zero?
        add_force_by_gravity
      end

      # Apply forces
      last_position = @position
      apply_forces(max_speed: @speed)

      # Check collision after gravity moving
      if @solid && @position != last_position
        @on_floor = false
        manage_collisions(last_position)
      end
    end

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
    actor = self.class.new(@image_name)
    actor.image_name = @image_name
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
  #     actor.image_name = "jump"
  #   end
  def on_jumping(&block)
    @on_jumping_callback = block
  end

  # The block to be executed when the Actor touches floor
  #
  # @example Change image when jumping
  #   actor = Actor.new("walk")
  #   actor.on_floor do
  #     actor.image_name = "land"
  #     Clock.new { actor.image_name = "walk" }.run_on(seconds: 0.8)
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
  #       self.image_name = "jump"
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
  #       self.image_name = "land"
  #       Clock.new { self.image_name = "walk" }.run_on(seconds: 0.8)
  #     end
  #   end
  def on_floor_do
    instance_exec(&@on_floor_callback) unless @on_floor_callback.nil?
  end


  private

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
    Shape.rectangle(
      position: position_in_camera,
      width: width,
      height: height,
      color: Color.palette.transparent,
      stroke_color: Color.palette.red,
      stroke: 1
    ) if solid

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

      if other.position.y > (last_position.y + height)
        on_floor_do unless @on_floor

        @on_floor = true
        @jumping = false
        @velocity.y = 0
      end

      if other.position.y + other.height < last_position.y
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
    Global.actors.reject { |e| e == self }.select(&:solid?).select do |other|
      if(
        (@collision_with == "all" || @collision_with.include?(other.name)) &&
        (other.collision_with == "all" || other.collision_with.include?(name))
      )
        Utils.collision? self, other
      end
    end
  end
  # rubocop:enable Style/Next

  protected

  attr_accessor :on_after_move_callback, :on_collision_callback, :on_destroy_callback, :on_jumping_callback, :on_floor_callback
  attr_accessor :on_cursor_down_callback, :on_cursor_up_callback, :on_cursor_left_callback, :on_cursor_right_callback, :on_space_bar_callback, :on_mouse_button_left_callback
  attr_accessor :on_click_callback
end
