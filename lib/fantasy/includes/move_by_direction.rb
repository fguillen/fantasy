# frozen_string_literal: true

module MoveByDirection
  def move_by_direction
    velocity = @direction * @speed
    @physics_body.linear_velocity(velocity)
  end
end
