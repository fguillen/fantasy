# frozen_string_literal: true

# Here there are all the methods that can be used in the root level

Global.setup_proc = nil
Global.loop_proc = nil

# Defines the presentation Scene
#
# ```
# on_presentation do
#   HudText.new(position: Coordinates.new(10, 100), text: "Press space to start")
#
#   on_space_bar do
#     Global.go_to_game
#   end
# end
# ```
def on_presentation(&block)
  Global.presentation_proc = block
end

# Defines the game Scene
#
# ```
# on_game do
#   # [...]
#   if player.dead
#     Global.go_to_end
#   end
# end
# ```
def on_game(&block)
  Global.game_proc = block
end

# Defines the end Scene
#
# ```
# on_end do
#   HudText.new(position: Coordinates.new(10, 100), text: "You are dead. Press space to re-tart")
#
#   on_space_bar do
#     Global.go_to_presentation
#   end
# end
# ```
def on_end(&block)
  Global.end_proc = block
end

# @!visibility private
def on_setup(&block)
  Global.setup_proc = block
end

# Executes on every frame. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_loop do
#     Global.references.time = Time.at(Global.seconds_in_scene).utc.strftime("%M:%S")
#   end
# end
# ```
def on_loop(&block)
  Global.loop_proc = block
end

# @!visibility private
def on_button(&block)
  Global.button_proc = block
end

# Triggered any time space bar key is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_space_bar do
#     shoot_gun # for example
#   end
# end
# ```
def on_space_bar(&block)
  Global.space_bar_proc = block
end

# Triggered any time cursor up key is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_cursor_up do
#     look_ups # for example
#   end
# end
# ```
def on_cursor_up(&block)
  Global.cursor_up_proc = block
end

# Triggered any time cursor down key is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_cursor_down do
#     look_down # for example
#   end
# end
# ```
def on_cursor_down(&block)
  Global.cursor_down_proc = block
end

# Triggered any time cursor left key is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_cursor_left do
#     look_left # for example
#   end
# end
# ```
def on_cursor_left(&block)
  Global.cursor_left_proc = block
end

# Triggered any time cursor right key is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_cursor_right do
#     look_right # for example
#   end
# end
# ```
def on_cursor_right(&block)
  Global.cursor_right_proc = block
end

# Triggered any time mouse left button is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_mouse_button_left do
#     show_menu # for example
#   end
# end
# ```
def on_mouse_button_left(&block)
  Global.mouse_button_left_proc = block
end

# Triggered any time mouse right button is pressed. To be used inside one of the scene blocks (`on_presentation`, `on_game`, `on_end`)
# ```
# on_game do
#   on_mouse_button_right do
#     show_menu # for example
#   end
# end
# ```
def on_mouse_button_right(&block)
  Global.mouse_button_right_proc = block
end

# Starts the game. This method has to be called when all the desired scene blocks (`on_presentation`, `on_game`, `on_end`) have been declared.
# ```
# on_game do
#   # do game stuff
# end
#
# start!
# ```
def start!
  raise "'SCREEN_WIDTH' and 'SCREEN_HEIGHT' both have to be set at the beginning of the program" unless defined?(SCREEN_WIDTH) && defined?(SCREEN_HEIGHT)

  Global.setup
  Global.game = Game.new(SCREEN_WIDTH, SCREEN_HEIGHT)
  Global.game.show
end
