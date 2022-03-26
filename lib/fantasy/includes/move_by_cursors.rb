module MoveByCursor
  def move_by_cursors
    if Gosu.button_down?(Cursor.down) && @move_with_cursors_down
      move_by(Coordinates.down)
    end

    if Gosu.button_down?(Cursor.up) && @move_with_cursors_up
      move_by(Coordinates.up)
    end

    if Gosu.button_down?(Cursor.right) && @move_with_cursors_right
      move_by(Coordinates.right)
    end

    if Gosu.button_down?(Cursor.left) && @move_with_cursors_left
      move_by(Coordinates.left)
    end

    if Gosu.button_down?(Cursor.space_bar) && !@jumping && @on_floor && @move_with_cursors_jump
      jump
    end
  end

  def move_with_cursors(down: nil, up: nil, left: nil, right: nil, jump: false)
    puts "#{@name}: move_with_cursors(down: #{down}, up: #{up}, left: #{left}, right: #{right}), jump: #{jump}"

    if down.nil? and up.nil? and left.nil? and right.nil?
      down = true
      up = true
      left = true
      right = true
    end
    @move_with_cursors_down = down || false
    @move_with_cursors_up = up || false
    @move_with_cursors_left = left || false
    @move_with_cursors_right = right || false
    @move_with_cursors_jump = jump || false
  end

  def move_by(direction)
    @position += direction * @speed * Global.frame_time
  end
end
