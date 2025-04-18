# frozen_string_literal: true

module MoveByCursor
  # rubocop:disable Metrics/PerceivedComplexity
  def move_with_cursors(
    down: true,
    up: true,
    left: true,
    right: true,
    jump: false,
    continuous: false
  )
    @move_with_cursors_down = down || false
    @move_with_cursors_up = up || false
    @move_with_cursors_left = left || false
    @move_with_cursors_right = right || false
    @move_with_cursors_jump = jump || false

    @move_with_cursors_activated = true
    @continuous = continuous
  end
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable

  # @!visibility private
  def move_by_cursors
    return if !@move_with_cursors_activated

    any_direction = false

    if Gosu.button_down?(Cursor.down) && @move_with_cursors_down
      add_direction(Coordinates.down)
      any_direction = true
    end

    if Gosu.button_down?(Cursor.up) && @move_with_cursors_up
      add_direction(Coordinates.up)
      any_direction = true
    end

    if Gosu.button_down?(Cursor.right) && @move_with_cursors_right
      add_direction(Coordinates.right)
      any_direction = true
    end

    if Gosu.button_down?(Cursor.left) && @move_with_cursors_left
      add_direction(Coordinates.left)
      any_direction = true
    end

    if !@continuous && !any_direction
      @direction = Coordinates.zero
    end

    if Gosu.button_down?(Cursor.space_bar) && !@jumping && on_floor? && @move_with_cursors_jump
      jump
    end
  end
  # rubocop:enable

  private

  def add_direction(cursor_direction)
    @direction += cursor_direction
    @direction = @direction.normalize if @direction != Coordinates.zero
  end
end
