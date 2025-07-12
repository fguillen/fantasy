class Configuration
  def width(screen_width)
    raise "Screen width already set to #{Global.screen_width}" if Global.screen_width

    Global.screen_width = screen_width
  end

  def height(screen_height)
    raise "Screen height already set to #{Global.screen_height}" if Global.screen_height

    Global.screen_height = screen_height
  end

  def physics_pixels_per_meter(pixels_per_meter)
    Global.physics_pixels_per_meter = pixels_per_meter
  end

  def title(title)
    Global.window_title = title
  end
end
