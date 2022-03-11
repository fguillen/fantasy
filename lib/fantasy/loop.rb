class Game < Gosu::Window
  def initialize
    # TODO: require SCREEN_WIDTH and SCREEN_HEIGHT
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    Global.initialize

    Global.presentation_proc.call()
  end

  def button_down(button_id)
    case button_id
    when Gosu::KB_DOWN then Global.cursor_down_proc.call unless Global.cursor_down_proc.nil?
    when Gosu::KB_UP then Global.cursor_up_proc.call unless Global.cursor_up_proc.nil?
    when Gosu::KB_LEFT then Global.cursor_left_proc.call unless Global.cursor_left_proc.nil?
    when Gosu::KB_RIGHT then Global.cursor_right_proc.call unless Global.cursor_right_proc.nil?
    when Gosu::MS_LEFT then Global.mouse_button_left_proc.call unless Global.mouse_button_left_proc.nil?
    when Gosu::MS_RIGHT then Global.mouse_button_right_proc.call unless Global.mouse_button_right_proc.nil?
    when Gosu::KB_SPACE then Global.space_bar_proc.call unless Global.space_bar_proc.nil?
    end

    Global.button_proc.call(button_id) unless Global.button_proc.nil?

    super
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

    Global.loop_proc.call() unless Global.loop_proc.nil?
  end

  def draw
    Gosu.draw_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Global.background)

    (
      Global.actors +
      Global.hud_texts +
      Global.hud_images
    ).sort_by(&:layer).each do |e|
      e.draw
    end
  end
end
