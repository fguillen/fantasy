# frozen_string_literal: true

class Game < Gosu::Window
  def initialize(screen_width, screen_height)
    Camera.initialize
    Global.initialize(screen_width, screen_height)

    super(Global.screen_width, Global.screen_height)

    Global.presentation_proc.call
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def button_down(button_id)
    case button_id
    when Cursor.down then cursor_down_pressed
    when Cursor.up then cursor_up_pressed
    when Cursor.left then cursor_left_pressed
    when Cursor.right then cursor_right_pressed
    when Cursor.space_bar then space_bar_pressed

    when Mouse.left then mouse_button_left_pressed
    end

    Global.button_proc&.call(button_id)

    super
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def cursor_down_pressed
    Global.cursor_down_proc&.call
    invoke_input_method_in_entities("on_cursor_down_do")
  end

  def cursor_up_pressed
    Global.cursor_up_proc&.call
    invoke_input_method_in_entities("on_cursor_up_do")
  end

  def cursor_left_pressed
    Global.cursor_left_proc&.call
    invoke_input_method_in_entities("on_cursor_left_do")
  end

  def cursor_right_pressed
    Global.cursor_right_proc&.call
    invoke_input_method_in_entities("on_cursor_right_do")
  end

  def space_bar_pressed
    Global.space_bar_proc&.call
    invoke_input_method_in_entities("on_space_bar_do")
  end

  def mouse_button_left_pressed
    Global.mouse_button_left_proc&.call

    check_click
  end

  def update
    Global.update

    Global.actors.each(&:move)
    Global.hud_texts.each(&:move)
    Global.hud_images.each(&:move)
    Global.hud_images.each(&:move)
    Global.animations.each(&:update)
    Camera.main.move

    Global.loop_proc&.call
  end

  def draw
    Gosu.draw_rect(0, 0, Global.screen_width, Global.screen_height, Global.background)

    (
      Global.backgrounds +
      Global.tile_maps +
      Global.actors.select(&:visible) +
      Global.hud_texts +
      Global.hud_images +
      Global.shapes
    ).group_by(&:layer).sort.map { |e| e[1] }.each { |e| e.sort_by(&:creation_index).each(&:draw) }
  end

  def check_click
    (
      Global.actors +
      Global.shapes
    ).sort_by(&:layer).each do |e|
      e.on_click_do if Utils.collision_at?(e, mouse_x, mouse_y)
    end
  end

  private

  def invoke_input_method_in_entities(input_method_name)
    (
      Global.actors +
      Global.shapes
    ).sort_by(&:layer).each do |e|
      e.send(input_method_name)
    end
  end
end
