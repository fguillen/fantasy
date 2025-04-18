# frozen_string_literal: true

module Gravitier
  def add_force_by_gravity
    return if respond_to?(:is_on_floor) && is_on_floor

    puts ">>>> is_on_floor: #{is_on_floor}"

    add_force(Coordinates.down * @gravity)
  end
end
