# frozen_string_literal: true

module Jumper
  include Log

  def jump
    log "jump"
    @physics_body.impulse(direction: Coordinates.up, force: @jump_force)
    @jumping = true

    on_jumping_do
  end
end
