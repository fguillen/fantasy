class Camera
  include MoveByCursor

  attr_accessor :position, :direction, :speed

  def initialize(position: Coordinates.zero)
    @position = position
    @direction = Coordinates.zero
    @speed = 0
    @moving_with_cursors = false
    @on_after_move_callback = nil
  end

  def move_with_cursors
    @moving_with_cursors = true
  end

  def move
    calculate_direction_by_cursors if @moving_with_cursors

    if @direction != Coordinates.zero && !@speed.zero?
      @position = @position + (@direction * @speed * Global.frame_time)
    end

    @on_after_move_callback.call unless @on_after_move_callback.nil?
  end

  def on_after_move(&block)
    @on_after_move_callback = block
  end
end
