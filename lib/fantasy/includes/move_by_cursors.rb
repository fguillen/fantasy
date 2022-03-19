module MoveByCursor
  def add_forces_by_cursors
    if Gosu.button_down?(Gosu::KB_DOWN) && @move_with_cursors_down
      add_force(Coordinates.down * @speed)
    elsif Gosu.button_down?(Gosu::KB_UP) && @move_with_cursors_up
      add_force(Coordinates.up * @speed)
    elsif Gosu.button_down?(Gosu::KB_RIGHT) && @move_with_cursors_right
      add_force(Coordinates.right * @speed)
    elsif Gosu.button_down?(Gosu::KB_LEFT) && @move_with_cursors_left
      add_force(Coordinates.left * @speed)
    else
      # @velocity.x = 0
    end


  end

  def move_with_cursors(down: true, up: true, left: true, right: true, jump: false)
    puts "#{@name}: move_with_cursors(down: #{down}, up: #{up}, left: #{left}, right: #{right}), jump: #{jump}"
    @move_with_cursors_down = down
    @move_with_cursors_up = up
    @move_with_cursors_left = left
    @move_with_cursors_right = right
    @move_with_cursors_jump = jump
  end
end
