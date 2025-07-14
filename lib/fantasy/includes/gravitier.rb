# frozen_string_literal: true

module Gravitier
  def add_force_by_gravity
    return if @gravity.nil? || @gravity.zero?
    return if respond_to?(:on_floor?) && on_floor?

    physics_body.force(direction: Coordinates.down, force: @gravity)
  end
end
