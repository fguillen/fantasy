Global.setup_proc = nil
Global.loop_proc = nil

def on_presentation(&block)
  Global.presentation_proc = block
end

def on_game(&block)
  Global.game_proc = block
end

def on_end(&block)
  Global.end_proc = block
end

def on_setup(&block)
  Global.setup_proc = block
end

def on_loop(&block)
  Global.loop_proc = block
end

def on_button(&block)
  Global.button_proc = block
end

def on_space_bar(&block)
  Global.space_bar_proc = block
end

def on_cursor_up(&block)
  Global.cursor_up_proc = block
end

def on_cursor_down(&block)
  Global.cursor_down_proc = block
end

def on_cursor_left(&block)
  Global.cursor_left_proc = block
end

def on_cursor_right(&block)
  Global.cursor_right_proc = block
end

def on_mouse_button_left(&block)
  Global.mouse_button_left_proc = block
end

def on_mouse_button_right(&block)
  Global.mouse_button_right_proc = block
end

def start!
  Global.setup
  Global.game = Game.new
  Global.game.show
end
