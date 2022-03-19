module Jumper
  def add_force_by_jump
    if Gosu.button_down?(Gosu::KB_SPACE) && @move_with_cursors_jump && !@jumping && @on_floor
      execute_jump
    end

    if @jumping
      continue_jump
    end
  end

  def execute_jump
    @jumping = true
    @on_floor = false
    @final_vertical_position = @position.y - @jump
  end

  def continue_jump
    add_force(Coordinates.up * @jump)

    if(@position.y <= @final_vertical_position)
      @position.y = @final_vertical_position
      @jumping = false
    end
  end
end
