class Game < Gosu::Window
  def initialize
    # TODO: require SCREEN_WIDTH and SCREEN_HEIGHT
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    Global.initialize

    Global.presentation_proc.call()
  end

  def button_down(button_id)
    case button_id
    when Cursor.down then cursor_down_pressed
    when Cursor.up then cursor_up_pressed
    when Cursor.left then cursor_left_pressed
    when Cursor.right then cursor_right_pressed
    when Cursor.space_bar then space_bar_pressed

    when Mouse.left then mouse_button_left_pressed
    end

    Global.button_proc.call(button_id) unless Global.button_proc.nil?

    super
  end

  def cursor_down_pressed
    Global.cursor_down_proc.call unless Global.cursor_down_proc.nil?
    invoke_input_method("on_cursor_down_do")
  end

  def cursor_up_pressed
    Global.cursor_up_proc.call unless Global.cursor_up_proc.nil?
    invoke_input_method("on_cursor_up_do")
  end

  def cursor_left_pressed
    Global.cursor_left_proc.call unless Global.cursor_left_proc.nil?
    invoke_input_method("on_cursor_left_do")
  end

  def cursor_right_pressed
    Global.cursor_right_proc.call unless Global.cursor_right_proc.nil?
    invoke_input_method("on_cursor_right_do")
  end

  def space_bar_pressed
    Global.space_bar_proc.call unless Global.space_bar_proc.nil?
    invoke_input_method("on_space_bar_do")
  end

  def mouse_button_left_pressed
    Global.mouse_button_left_proc.call unless Global.mouse_button_left_proc.nil?

    check_click
  end

  def invoke_input_method(input_method_name)
    (
      Global.actors +
      Global.shapes
    ).sort_by(&:layer).each do |e|
      e.send(input_method_name)
    end
  end

  def update
    Global.update

    Global.actors.each do |e|
      e.move
    end

    Global.hud_texts.each do |e|
      e.move
    end

    Global.hud_images.each do |e|
      e.move
    end

    Global.camera.move

    Global.loop_proc.call() unless Global.loop_proc.nil?
  end

  def draw
    Gosu.draw_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Global.background)

    (
      Global.backgrounds +
      Global.tile_maps +
      Global.actors +
      Global.hud_texts +
      Global.hud_images +
      Global.shapes
    ).sort_by(&:layer).each do |e|
      e.draw
    end
  end

  def check_click
    (
      Global.actors +
      Global.shapes
    ).sort_by(&:layer).each do |e|
      e.on_click_do if Utils.collision_at?(e, mouse_x, mouse_y)
    end
  end
end
