module Mover
  def add_force(force)
    @acceleration ||= Coordinates.zero
    @acceleration += force
  end

  def apply_forces(max_speed:)
    @acceleration ||= Coordinates.zero
    @velocity ||= Coordinates.zero

    @velocity += @acceleration

    unless @velocity.length.zero?
      @velocity = @velocity.normalize * max_speed * Global.frame_time
      @position += @velocity
    end

    @acceleration = Coordinates.zero
  end
end
