# frozen_string_literal: true

module Jumper
  def jump
    impulse(direction: Coordinates.up, force: @jump_force)
    @jumping = true
    @on_floor = false

    on_jumping_do
  end
end
