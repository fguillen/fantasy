# frozen_string_literal: true

module Jumper
  include Log

  def jump
    log "jump"
    impulse(direction: Coordinates.up, force: @jump_force)
    @jumping = true
    @is_on_floor = false

    on_jumping_do
  end
end
