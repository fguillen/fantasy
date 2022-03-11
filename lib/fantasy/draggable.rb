module Draggable
  def drag
    puts "XXX: dragging 1 #{name}"
    mouse_position = Global.mouse_position

    puts "@draggable_on_debug: #{@draggable_on_debug}"
    puts "@dragging: #{@dragging}"
    puts "Gosu.button_down?(Gosu::MS_LEFT): #{Gosu.button_down?(Gosu::MS_LEFT)}"
    puts "collision: #{Utils.collision_at?(self, mouse_position.x, mouse_position.y)}"

    if @draggable_on_debug && !@dragging && Gosu.button_down?(Gosu::MS_LEFT) && Utils.collision_at?(self, mouse_position.x, mouse_position.y)
      puts "XXX: dragging start #{name}"
      @dragging = true
      @dragging_offset = mouse_position - @position
    end

    if @dragging && !Gosu.button_down?(Gosu::MS_LEFT)
      puts "XXX: dragging end #{name}"
      @dragging = false
    end

    if @dragging
      puts "XXX: dragging 3 #{name}"
      @position = mouse_position - @dragging_offset
    end
  end
end
