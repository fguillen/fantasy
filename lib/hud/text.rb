# frozen_string_literal: true

class Hud::Text
  include Log
  include Indexable

  attr_accessor :text, :size, :color, :background_color, :visible, :layer, :in_world, :position, :alignment

  def initialize(text: "", position: Coordinates.zero, hud: nil)
    @position = position
    @text = text
    @size = "medium"
    @color = Color.palette.white
    @background_color = Color.palette.black
    @visible = true
    @layer = 100
    @in_world = false
    @alignment = "top-left"

    @hud = hud || Global.hud
    @hud.add_part(self)

    Global.hud_texts&.push(self)
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    if visible
      unless @background_color.nil?
        font.draw_markup_rel(text, screen_position.x + shadow_offset, screen_position.y + shadow_offset, 1, position_rel.x, position_rel.y, 1, 1, background_color)
      end
      font.draw_markup_rel(text, screen_position.x, screen_position.y, 1, position_rel.x, position_rel.y, 1, 1, color)
    end

    draw_debug if Global.debug
  end
  # rubocop:enable Metrics/AbcSize

  def font
    found_font = Global.pixel_fonts[@size]
    if found_font.nil?
      raise "HudText.size value not valid '#{@size}'. Valid values: 'small, medium, big, huge'"
    end

    found_font
  end

  def destroy
    log("#destroy")
    @hud&.remove_part(self)
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
    when "bottom-left"
      Coordinates.new(0, 1)
    when "bottom-right"
      Coordinates.new(1, 1)
    when "bottom-center"
      Coordinates.new(0.5, 1)
    when "center"
      Coordinates.new(0.5, 0.5)
    else
      raise "HudText.alignment value not valid '#{@alignment}'. Valid values: 'top-left, top-right, top-center, bottom-left, bottom-right, bottom-center, center'"
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
      @position - Camera.main.position
    else
      @position
    end
  end

  def draw_debug
    Global.pixel_fonts["medium"].draw_text("#{@position.x.floor},#{@position.y.floor}", screen_position.x, screen_position.y, 1)
  end
end
