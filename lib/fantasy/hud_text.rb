class HudText
  attr_accessor :text, :size, :color, :visible, :layer, :in_world, :position

  def initialize(position:, text: "")
    @position = position
    @text = text
    @size = "medium"
    @color = Gosu::Color::WHITE
    @visible = true
    @layer = 100
    @in_world = false

    Global.hud_texts.push(self)
  end

  def move; end

  def draw
    if visible
      Global.pixel_font.draw_markup(text, screen_position.x + scale, screen_position.y - 20 + scale, 1, scale, scale, Gosu::Color::BLACK)
      Global.pixel_font.draw_markup(text, screen_position.x, screen_position.y - 20, 1, scale, scale, color)
    end

    draw_debug if Global.debug
  end

  def scale
    case @size
    when "small"
      1
    when "medium"
      2
    when "big"
      3
    when "huge"
      4
    else
      raise "HudText.size not valid '#{@size}'. Valid sizes: 'small, medium, big, huge'"
    end
  end

  def screen_position
    if @in_world
      @position - Global.camera.position
    else
      @position
    end
  end

  def destroy
    Global.hud_texts.delete(self)
  end

  def draw_debug
    Global.pixel_font.draw_text("#{@position.x.floor},#{@position.y.floor}", @position.x, @position.y, 1)
  end
end
