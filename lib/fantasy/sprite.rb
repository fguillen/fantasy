# frozen_string_literal: true

class Sprite < Graphic
  include ActorComponent

  attr_reader :image

  def initialize(
    image_name_or_gosu_image,
    actor:,
    position: Coordinates.zero,
    name: nil
  )
    super(actor: actor, position: position, name: name)

    @image =
      if image_name_or_gosu_image.is_a?(Image)
        image_name_or_gosu_image
      else
        Image.load(image_name_or_gosu_image)
      end

    @name ||= @image.name
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  def draw
    scale_x = scale_in_world
    scale_y = scale_in_world
    scale_x *= -1 if %w[horizontal both].include?(flip)
    scale_y *= -1 if %w[vertical both].include?(flip)
    x = position_in_camera.x
    y = position_in_camera.y

    # draw_rot(x, y, z = 0, angle = 0, center_x = 0.5, center_y = 0.5, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
    @image.draw_rot(x + ((width * scale) / 2), y + ((height * scale) / 2), 0, rotation_in_world, 0.5, 0.5, scale_x, scale_y)
  end

  def width
    @image.width
  end

  def height
    @image.height
  end
end
