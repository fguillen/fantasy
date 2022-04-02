# frozen_string_literal: true

module Draggable
  # rubocop:disable Style/GuardClause
  def drag
    mouse_position = Global.mouse_position

    start_dragging?
    stop_dragging?
    drag?
  end
  # rubocop:enable Style/GuardClause

  private

  def start_dragging?
    if(
      @draggable_on_debug &&
      !@dragging &&
      Gosu.button_down?(Gosu::MS_LEFT) &&
      Utils.collision_at?(self, mouse_position.x, mouse_position.y)
    )
      @dragging = true
      @dragging_offset = mouse_position - @position
    end
  end

  def stop_dragging?
    if @dragging && !Gosu.button_down?(Gosu::MS_LEFT)
      @dragging = false
    end
  end

  def drag?
    if @dragging
      @position = mouse_position - @dragging_offset
    end
  end
end
