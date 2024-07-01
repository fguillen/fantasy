# frozen_string_literal: true

class Shape
  include UserInputs
  include Indexable

  attr_accessor :kind, :position, :width, :height, :stroke, :color, :fill, :stroke_color, :layer

  # rubocop:disable Metrics/ParameterLists
  def initialize(kind: "rectangle", position: Coordinates.zero, width: 10, height: 10, stroke: 1, fill: true, color: Color.palette.gold, stroke_color: nil)
    @kind = kind
    @position = position
    @width = width
    @height = height
    @stroke = stroke
    @color = color
    @fill = fill
    @stroke_color = stroke_color
    @layer = 1

    Global.shapes&.push(self)
  end
  # rubocop:enable Metrics/ParameterLists

  def self.rectangle(position: Coordinates.zero, width: 10, height: 10, stroke: 1, fill: true, color: Color.palette.gold, stroke_color: nil)
    Shape.new(kind: "rectangle", position: position, width: width, height: height, color: color)
  end

  def draw
    case @kind
    when "rectangle"
      draw_rectangle
    else
      raise "Shape.kind not supported: '#{@kind}'. Supported kinds: 'rectangle'"
    end
  end

  def destroy
    Global.shapes.delete(self)
  end

  private

  # rubocop:disable Style/GuardClause
  def draw_rectangle
    if fill
      Gosu.draw_rect(@position.x, @position.y, @width, @height, @color)
    end

    unless stroke.zero?
      draw_frame(@position.x, @position.y, @width, @height, @stroke, @stroke_color || @color)
    end
  end
  # rubocop:enable Style/GuardClause

  # rubocop:disable Metrics/ParameterLists
  def draw_frame(x, y, width, height, stroke, color)
    Gosu.draw_rect(x, y, width, stroke, color)
    Gosu.draw_rect(width - stroke + x, y, stroke, height, color)
    Gosu.draw_rect(x, height - stroke + y, width, stroke, color)
    Gosu.draw_rect(x, y, stroke, height, color)
  end
  # rubocop:enable Metrics/ParameterLists
end
