# frozen_string_literal: true

module Gravitier
  def add_force_by_gravity
    return if @gravity.nil? || @gravity.zero?
    return if respond_to?(:on_floor?) && on_floor?

    physics_body.force(direction: Coordinates.down, force: @gravity)

    # physics_velocity = Box2D::Body_GetLinearVelocity(physics_body.id)
    # puts "Actor velocity 2: #{physics_velocity.x}, #{physics_velocity.y}"
  end
end
