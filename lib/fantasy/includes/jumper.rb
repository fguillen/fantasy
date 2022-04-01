# frozen_string_literal: true

module Jumper
  def jump
    add_force(Coordinates.up * @jump_force)
    @jumping = true
    @on_floor = false
    @final_vertical_position = @position.y - @jump_force

    on_jumping_do
  end
end
