module MoveByDirection
  def move_by_direction
    @position += @direction * @speed * Global.frame_time
  end
end
