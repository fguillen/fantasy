class HudImage
  include Draggable

  attr_accessor :name, :scale, :color, :visible, :position, :layer

  def initialize(position:, image_name: )
    @image = Gosu::Image.new("#{__dir__}/../images/#{image_name}.png", { retro: true })
    @name = image_name
    @position = position
    @scale = 1
    @visible = true
    @draggable_on_debug = true
    @dragging = false
    @layer = 100

    Global.hud_images.push(self)
  end

  def width
    @image.width() * @scale
  end

  def height
    @image.height() * @scale
  end

  def move
    drag if Global.debug
  end

  def draw
    if visible
      @image.draw(@position.x, @position.y, 0, @scale, @scale)
    end

    draw_debug if Global.debug
  end

  def draw_debug
    Global.pixel_font.draw_text("#{@position.x.floor},#{@position.y.floor}", @position.x, @position.y - 20, 1)
  end

  def destroy
    Global.hud_images.delete(self)
  end
end
