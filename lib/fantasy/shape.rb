# frozen_string_literal: true

class Shape
  include UserInputs
  include Indexable

  attr_accessor :kind, :position, :width, :height, :stroke, :color, :fill, :stroke_color, :layer

  # rubocop:disable Metrics/ParameterLists
  def initialize(
    kind: "rectangle",
    position: Coordinates.zero,
    width: 10,
    height: 10,
    stroke: 1,
    fill: true,
    color: Color.palette.gold,
    stroke_color: nil,
    from: Coordinates.zero,
    to: Coordinates.new(10, 10)
  )
    @kind = kind
    @position = position
    @width = width
    @height = height
    @stroke = stroke
    @color = color
    @fill = fill
    @stroke_color = stroke_color
    @layer = 1
    @from = from
    @to = to

    # @errors = []
    # raise "Error: Shape kind '#{kind}' is invalid. #{errors.join(", ")}" if invalid?
  end
  # rubocop:enable Metrics/ParameterLists

  def self.rectangle(
    position: Coordinates.zero,
    width: 10,
    height: 10,
    stroke: 1,
    fill: true,
    color: Color.palette.gold,
    stroke_color: nil
  )
    Shape.new(kind: "rectangle", position:, width:, height:, stroke:, fill:, color:, stroke_color:)
  end

  def self.line(
    from:,
    to:,
    stroke: 1,
    color: Color.palette.gold
  )
    Shape.new(kind: "line", from:, to:, stroke:, stroke_color: color)
  end

  def draw
    case @kind
    when "rectangle"
      draw_rectangle
    when "line"
      draw_line
    else
      raise "Shape.kind not supported: '#{@kind}'. Supported kinds: 'rectangle'"
    end
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

  def draw_line
    # Gosu.draw_line(@from.x, @from.y, @stroke_color, @to.x, @to.y, @stroke_color)
    direction = @from.direction(@to)
    perpendicular = direction.perpendicular
    coordinate_a = @from + (perpendicular * (@stroke / 2.to_f))
    coordinate_b = @from - (perpendicular * (@stroke / 2.to_f))
    coordinate_c = @to + (perpendicular * (@stroke / 2.to_f))
    coordinate_d = @to - (perpendicular * (@stroke / 2.to_f))

    Gosu.draw_quad(
      coordinate_a.x, coordinate_a.y, @stroke_color,
      coordinate_b.x, coordinate_b.y, @stroke_color,
      coordinate_c.x, coordinate_c.y, @stroke_color,
      coordinate_d.x, coordinate_d.y, @stroke_color
    )
  end

  # rubocop:disable Metrics/ParameterLists
  def draw_frame(x, y, width, height, stroke, color)
    Gosu.draw_rect(x, y, width, stroke, color)
    Gosu.draw_rect(width - stroke + x, y, stroke, height, color)
    Gosu.draw_rect(x, height - stroke + y, width, stroke, color)
    Gosu.draw_rect(x, y, stroke, height, color)
  end
  # rubocop:enable Metrics/ParameterLists


end
