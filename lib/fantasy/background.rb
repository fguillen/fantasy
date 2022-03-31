class Background
  attr_accessor :scale, :color, :visible, :position, :layer, :replicable

  def initialize(image_name:)
    @image = Image.new(image_name)
    @name = image_name
    @position = Coordinates.zero
    @scale = 1
    @visible = true
    @draggable_on_debug = true
    @dragging = false
    @layer = -100
    @replicable = true

    Global.backgrounds.push(self)
  end

  def width
    @image.width() * @scale
  end

  def height
    @image.height() * @scale
  end

  def position_in_camera
    @position - Global.camera.position
  end

  def draw
    if @visible
      if @replicable
        draw_replicable
      else
        draw_normal
      end
    end
  end

  def draw_normal
    @image.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale)
  end

  # Camera relative Tiles
  def draw_replicable
    tiles_delta_x = (position_in_camera.x % width) - width
    tiles_delta_y = (position_in_camera.y % height) - height

    tiles_needed_horizontal = ((SCREEN_WIDTH - (tiles_delta_x + width)) / width.to_f).ceil + 1
    tiles_needed_vertical = ((SCREEN_HEIGHT - (tiles_delta_y + height)) / height.to_f).ceil + 1

    tiles_needed_horizontal.times do |index_horizontal|
      tiles_needed_vertical.times do |index_vertical|
        @image.draw(x: tiles_delta_x + (width * index_horizontal), y: tiles_delta_y + (height * index_vertical), scale: @scale)
      end
    end
  end

  def destroy
    Global.backgrounds.delete(self)
  end
end
