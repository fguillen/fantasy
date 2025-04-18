# frozen_string_literal: true

class HudImage
  include Draggable
  include Indexable

  attr_accessor :name, :scale, :color, :visible, :position, :layer

  def initialize(image_name:, position: Coordinates.zero)
    @image = Image.new(image_name)
    @name = image_name
    @position = position
    @scale = 1
    @visible = true
    @draggable_on_debug = true
    @dragging = false
    @layer = 100

    Global.hud_images&.push(self)
  end

  def width
    @image.width * @scale
  end

  def height
    @image.height * @scale
  end

  def move
    drag if Global.debug
  end

  def draw
    if visible
      @image.draw(position: @position, scale: @scale)
    end

    draw_debug if Global.debug
  end

  def draw_debug
    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", @position.x, @position.y - 20, 1)
  end

  def destroy
    Global.hud_images.delete(self)
  end
end
