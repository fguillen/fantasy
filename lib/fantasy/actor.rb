class Actor
  include MoveByCursor
  include MoveByDirection
  include Mover
  include Gravitier
  include Jumper

  attr_reader :image, :moving_with_cursors
  attr_accessor :image_name, :position, :direction, :speed, :jump, :gravity, :solid, :scale, :name, :layer
  attr_accessor :collision_during_jumping, :collision_with

  def initialize(image_name)
    @image_name = image_name
    @image = Image.new(image_name)
    @name = image_name
    @position = Coordinates.zero
    @direction = Coordinates.zero
    @speed = 0
    @scale = 1

    @moving_with_cursors = false
    @solid = false
    @draggable_on_debug = true
    @dragging = false
    @dragging_offset = nil
    @layer = 0
    @gravity = 0
    @jump = 0
    @collision_during_jumping = false
    @collision_with = "all"

    @on_floor = false

    @on_after_move_callback = nil
    @on_collision_callback = nil
    @on_destroy_callback = nil
    @on_start_jumping_callback = nil
    @on_start_falling_callback = nil

    Global.actors << self
  end

  def image=(image_name)
    @image = Image.new(image_name)
  end

  def width
    @image.width() * @scale
  end

  def height
    @image.height() * @scale
  end

  def direction=(value)
    @direction = value
    @direction = @direction.normalize unless @direction.zero?
  end

  def draw
    @image.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale)

    draw_debug if Global.debug
  end

  def draw_debug
    Utils.draw_frame(position_in_camera.x, position_in_camera.y, width, height, 1, Gosu::Color::RED) if solid
    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end

  def position_in_camera
    @position - Global.camera.position
  end

  # TODO: I made more of this code while I was with Covid
  # It looks horrible and it is crap
  # I'll improve it some day :)
  def move
    mouse_position = Global.mouse_position + Global.camera.position

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
      @solid_temporal = @solid

      # if we are in collision before move we make the Actor no solid
      # to allow it to move until collision is off
      if collisions.any?
        @solid = false
      end

      # Direction moving
      unless @direction.zero?
        @velocity = Coordinates.zero
        last_position = @position
        add_forces_by_direction
        apply_forces(max_speed: @speed)

        # Check collision after cursor moving
        if @solid && @position != last_position && !(@jumping && !@collision_during_jumping)
          manage_collisions(last_position)
        end
      end


      # Cursors moving
      @velocity = Coordinates.zero
      last_position = @position
      add_forces_by_cursors
      apply_forces(max_speed: @speed)

      # Check collision after cursor moving
      if @solid && @position != last_position && !(@jumping && !@collision_during_jumping)
        manage_collisions(last_position)
      end


      # Jump moving
      unless @jump.zero?
        @velocity = Coordinates.zero
        last_position = @position
        add_force_by_jump
        apply_forces(max_speed: @speed)

        # Check collision after jump moving
        # only if collision_during_jumping is true
        if @solid && @collision_during_jumping && @position != last_position
         if manage_collisions(last_position)
            @jumping = false
         end
        end
      end


      # Gravity moving
      if !@gravity.zero? && !@jumping
        @velocity = Coordinates.zero
        last_position = @position
        add_force_by_gravity
        apply_forces(max_speed: @gravity)

        # Check collision after gravity moving
        if @solid && @position != last_position
          @on_floor = false
          manage_collisions(last_position)
        end
      end

      @solid = @solid_temporal
    end

    on_after_move_do
  end

  def manage_collisions(last_position)
    collisions.each do |other|
      on_collision_do(other)
      other.on_collision_do(self)

      if other.position.y > (last_position.y + height)
        @on_floor = true
      end
    end

    if collisions.any? # we don't cache collisions because position may be changed on collision callback
      @position = last_position

      return true
    end

    false
  end

  def solid?
    @solid
  end

  # Set callbacks
  def on_after_move(&block)
    @on_after_move_callback = block
  end

  def on_collision(&block)
    @on_collision_callback = block
  end

  def on_destroy(&block)
    @on_destroy_callback = block
  end

  def on_start_jumping(&block)
    @on_start_jumping_callback = block
  end

  def on_start_falling(&block)
    @on_start_falling_callback = block
  end


  # Execute callbacks
  def on_after_move_do
    instance_exec(&@on_after_move_callback) unless @on_after_move_callback.nil?
  end

  def on_collision_do(other)
    instance_exec(other, &@on_collision_callback) unless @on_collision_callback.nil?
  end

  def on_destroy_do
    instance_exec(&@on_destroy_callback) unless @on_destroy_callback.nil?
  end

  def on_start_jumping_do
    instance_exec(&@on_start_jumping_callback) unless @on_start_jumping_callback.nil?
  end

  def on_start_falling_do
    instance_exec(&@on_start_falling_callback) unless @on_start_falling_callback.nil?
  end



  def collisions
    Global.actors.reject { |e| e == self }.select { |e| e.solid? }.select do |other|
      if(
        (@collision_with == "all" || @collision_with.include?(other.name)) &&
        (other.collision_with == "all" || other.collision_with.include?(self.name))
      )
        Utils.collision? self, other
      end
    end
  end

  def destroy
    on_destroy_do
    Global.actors.delete(self)
  end

  def clone
    actor = self.class.new(@image_name)
    actor.image_name = @image_name
    actor.name = @name
    actor.position = @position.clone
    actor.direction = @direction.clone

    actor.speed = @speed
    actor.scale = @scale
    actor.moving_with_cursors if @moving_with_cursors
    actor.solid = @solid
    actor.layer = @layer
    actor.gravity = @gravity
    actor.jump = @jump
    actor.collision_during_jumping = @collision_during_jumping
    actor.collision_with = @collision_with

    actor.on_after_move_callback = @on_after_move_callback
    actor.on_collision_callback = @on_collision_callback
    actor.on_destroy_callback = @on_destroy_callback
    actor.on_start_jumping = @on_start_jumping_callback
    actor.on_start_falling = @on_start_falling_callback

    actor
  end

  protected

  def on_after_move_callback=(block)
    @on_after_move_callback = block
  end

  def on_collision_callback=(block)
    @on_collision_callback = block
  end

  def on_destroy_callback=(block)
    @on_destroy_callback = block
  end

  def on_start_jumping=(block)
    @on_start_jumping_callback = block
  end

  def on_start_falling=(block)
    @on_start_falling_callback = block
  end
end
