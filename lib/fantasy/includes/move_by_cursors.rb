module MoveByCursor
  def calculate_direction_by_cursors
    if Gosu.button_down?(Gosu::KB_DOWN)
      @direction = Coordinates.down
    elsif Gosu.button_down?(Gosu::KB_UP)
      @direction = Coordinates.up
    elsif Gosu.button_down?(Gosu::KB_RIGHT)
      @direction = Coordinates.right
    elsif Gosu.button_down?(Gosu::KB_LEFT)
      @direction = Coordinates.left
    else
      @direction = Coordinates.zero
    end
  end
end
