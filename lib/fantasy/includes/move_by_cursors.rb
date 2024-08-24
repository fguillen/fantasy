# frozen_string_literal: true

module MoveByCursor
  # rubocop:disable Metrics/PerceivedComplexity
  def move_with_cursors(down: nil, up: nil, left: nil, right: nil, jump: false, continuous: false)
    if down.nil? && up.nil? && left.nil? && right.nil?
      down = true
      up = true
      left = true
      right = true
    end

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

    if Gosu.button_down?(Cursor.down) && @move_with_cursors_down
      move_in_direction(Coordinates.down)

    elsif Gosu.button_down?(Cursor.up) && @move_with_cursors_up
      move_in_direction(Coordinates.up)

    elsif Gosu.button_down?(Cursor.right) && @move_with_cursors_right
      move_in_direction(Coordinates.right)

    elsif Gosu.button_down?(Cursor.left) && @move_with_cursors_left
      move_in_direction(Coordinates.left)

    elsif !@continuous
      move_in_direction(Coordinates.zero)
    end

    if Gosu.button_down?(Cursor.space_bar) && !@jumping && @on_floor && @move_with_cursors_jump
      jump
    end
  end
  # rubocop:enable

  private

  def move_in_direction(cursor_direction)
    @direction = cursor_direction
    # @position += direction * @speed * Global.frame_time
  end
end
