module Mover
  def impulse(direction:, force:)
    add_force(direction.normalize * force)
  end

  def add_force(force)
    @acceleration ||= Coordinates.zero
    @acceleration += force
  end

  def apply_forces(max_speed: Float::INFINITY)
    @acceleration ||= Coordinates.zero
    @velocity ||= Coordinates.zero

    @velocity += @acceleration
    @velocity.resize(max_speed) if @velocity.length > max_speed

    unless @velocity.length.zero?
      @position += @velocity * Global.frame_time
    end

    @acceleration = Coordinates.zero
  end
end
