class Background
  attr_accessor :scale, :color, :visible, :position, :layer

  def initialize(image_name:)
    @image = Image.new(image_name)
    @name = image_name
    @position = Coordinates.zero
    @scale = 1
    @visible = true
    @draggable_on_debug = true
    @dragging = false
    @layer = -100

    Global.backgrounds.push(self)
  end

  def width
    @image.width() * @scale
  end

  def height
    @image.height() * @scale
  end

  def draw
    if visible
      @image.draw(x: @position.x, y: @position.y, scale: @scale)
    end
  end

  def destroy
    Global.backgrounds.delete(self)
  end
end
