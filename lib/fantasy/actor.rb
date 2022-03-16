class Actor
  include MoveByCursor

  attr_reader :image, :moving_with_cursors
  attr_accessor :image_name, :position, :direction, :speed, :solid, :scale, :name, :layer

  def initialize(image_name)
    @image_name = image_name
    @image = Image.new(image_name)
    @name = image_name
    @position = Coordinates.new(0, 0)
    @direction = Coordinates.new(0, 0)
    @speed = 0
    @scale = 1
    @on_after_move_callback = nil
    @moving_with_cursors = false
    @solid = false
    @draggable_on_debug = true
    @dragging = false
    @dragging_offset = nil
    @layer = 0

    @on_collision_callback = nil

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

  def move_with_cursors
    @moving_with_cursors = true
  end

  def direction=(value)
    @direction = value
    @direction = @direction.normalize
  end

  def draw
    @image.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale)

    draw_debug if Global.debug
  end

  def draw_debug
    Utils.draw_frame(position_in_camera.x, position_in_camera.y, width, height, 1, Gosu::Color::RED) if solid
    Global.pixel_font.draw_text("#{@position.x.floor},#{@position.y.floor}", position_in_camera.x, position_in_camera.y - 20, 1)
  end

  def position_in_camera
    @position - Global.camera.position
  end

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
      calculate_direction_by_cursors if @moving_with_cursors

      if @direction != Coordinates.zero && !@speed.zero?
        @last_position = @position
        @position = @position + (@direction * @speed * Global.frame_time)

        if solid?
          collisions.each do |actor|
            collision_with(actor)
            actor.collision_with(self)
          end

          @position = @last_position if collisions.any? # we don't cache collisions because position may be changed on collision callback
        end
      end
    end

    @on_after_move_callback.call unless @on_after_move_callback.nil?
  end

  def solid?
    @solid
  end

  def on_after_move(&block)
    @on_after_move_callback = block
  end

  def on_collision(&block)
    @on_collision_callback = block
  end

  def on_destroy(&block)
    @on_destroy_callback = block
  end

  def collision_with(actor)
    @on_collision_callback.call(actor) unless @on_collision_callback.nil?
  end

  def collisions
    Global.actors.reject { |e| e == self }.select { |e| e.solid? }.select do |actor|
      Utils.collision? self, actor
    end
  end

  def destroy
    @on_destroy_callback.call unless @on_destroy_callback.nil?
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

    actor.on_after_move_callback = @on_after_move_callback
    actor.on_collision_callback = @on_collision_callback
    actor.on_destroy_callback = @on_destroy_callback

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
end
