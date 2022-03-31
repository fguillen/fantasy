class HudText
  attr_accessor :text, :size, :color, :background_color, :visible, :layer, :in_world, :position, :alignment

  def initialize(position:, text: "")
    @position = position
    @text = text
    @size = "medium"
    @color = Color.palette.white
    @background_color = Color.palette.black
    @visible = true
    @layer = 100
    @in_world = false
    @alignment = "top-left"

    Global.hud_texts.push(self)
  end

  def move; end

  def draw
    if visible
      unless @background_color.nil?
        font.draw_markup_rel(text, screen_position.x + shadow_offset, screen_position.y + shadow_offset, 1, position_rel.x, position_rel.y, 1, 1, background_color)
      end
      font.draw_markup_rel(text, screen_position.x, screen_position.y, 1, position_rel.x, position_rel.y, 1, 1, color)
    end

    draw_debug if Global.debug
  end

  def font
    found_font = Global.pixel_fonts[@size]
    if found_font.nil?
      raise "HudText.size value not valid '#{@size}'. Valid values: 'small, medium, big, huge'"
    end
    found_font
  end

  def destroy
    Global.hud_texts.delete(self)
  end

  def width
    font.markup_width(text, 1)
  end


  private

  def position_rel
    case @alignment
    when "top-left"
      Coordinates.new(0, 0)
    when "top-right"
      Coordinates.new(1, 0)
    when "top-center"
      Coordinates.new(0.5, 0)
    when "center"
      Coordinates.new(0.5, 0.5)
    else
      raise "HudText.alignment value not valid '#{@alignment}'. Valid values: 'top-left, top-right, top-center, center'"
    end
  end

  def shadow_offset
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
      raise "HudText.size value not valid '#{@size}'. Valid sizes: 'small, medium, big, huge'"
    end
  end

  def screen_position
    if @in_world
      @position - Global.camera.position
    else
      @position
    end
  end

  def draw_debug
    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", screen_position.x, screen_position.y, 1)
  end
end
