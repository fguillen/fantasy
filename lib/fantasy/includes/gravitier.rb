module Gravitier
  def add_force_by_gravity
    add_force(Coordinates.down * @gravity)
  end
end
