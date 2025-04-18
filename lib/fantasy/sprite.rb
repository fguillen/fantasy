# frozen_string_literal: true

class Sprite < Graphic
  include ActorPart

  attr_reader :image

  def initialize(
    image_name_or_gosu_image,
    actor: nil,
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
    x = position_in_camera.x
    y = position_in_camera.y

    @image.draw(x: x, y: y, scale: scale_in_world, rotation: rotation_in_world, flip: flip)
  end
end
