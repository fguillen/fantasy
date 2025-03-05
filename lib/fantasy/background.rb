# frozen_string_literal: true

# Represents on static image that will be rendered on every frame.
# Replicable (by default).
# The position is relative to `Camera.main`.
# ```
# on_game do
#   background = Background.new(image_name: "beach")
#   # background.repeat = false # if you don't want the image to replicate
#   background.scale = 6
# end
# ```
class Background
  include Indexable

  # In which layer the image of the Background is rendered.
  # Smaller numbers are rendered behind higher numbers.
  #
  # Default `-100`.
  #
  # @example Set layer
  #   background = Background.new("image")
  #   background.layer = -50
  attr_accessor :layer

  # Coordinates object where x and y represent the position of the Background in the World
  # (no necessarily in the Screen).
  #
  # Default `Coordinates.zero`.
  #
  # @example Setting position
  #   background = Background.new("image")
  #   background.position = Coordinates.new(10, 20)
  #   background.position.x # => 10
  #
  # @example Modify position
  #   background.position.x +=  1
  #   background.position.x # => 11
  attr_accessor :position

  # [Boolean] When `true` the image will replicate itself to cover all the screen.
  # [symbol] When `:both` is the same as `true`
  #          When `:vertical` only repeats vertically
  #          When `:horizontal` only repeats horizontally
  #
  # Default `true`.
  #
  # @example Setting repeat to `false`
  #   background = Background.new("image")
  #   background.repeat = false
  attr_accessor :repeat

  # The value to scale the image of the Background when drawn.
  # If the value is `2` the image will rendered at double of size.
  # If the value is `0.5` the image will rendered at half of size.
  #
  # @note this value affects the attributes `width` and `height`
  #
  # Default `1`.
  #
  # @example Set scale
  #   background = Background.new("image")
  #   background.scale = 6
  attr_accessor :scale

  # When `false` the Background won't be rendered in the next frame.
  #
  # Default `true`.
  #
  # @example Set visible
  #   background = Background.new("image")
  #   background.visible = false
  attr_accessor :visible

  # Generates an Background with all the below default values:
  # - **position**: `Coordinates.zero`.
  # - **scale**: `1`.
  # - **draggable_on_debug**: `true`.
  # - **layer**: `-100`.
  # - **image**: The Image generated by `image_name`
  # - **name**: Same as `image_name`
  # - **visible**: `true`
  # - **repeat**: `false`
  #
  # @param image_name [string] the name of the image file from `./images/*`
  # @return [Background] the Background
  # @example Instantiate a new Background
  #   background = Background.new("background")
  def initialize(image_name:)
    @image = Image.new(image_name)
    @position = Coordinates.zero
    @scale = 1
    @visible = true
    @draggable_on_debug = true
    @dragging = false
    @layer = -100
    @repeat = true

    Global.backgrounds&.push(self)
  end

  # @return [Fixnum] the Background width in pixels
  def width
    @image.width * @scale
  end

  # @return [Fixnum] the Background height in pixels
  def height
    @image.height * @scale
  end

  # rubocop:disable Style/GuardClause

  # @!visibility private
  def draw
    if @visible
      if @repeat
        draw_repeat
      else
        draw_normal
      end
    end
  end
  # rubocop:enable Style/GuardClause

  # Destroy this Background and it will not longer be rendered
  #
  # @example Destroy a Background
  #   background = Background.new("background")
  #   background.destroy
  def destroy
    Global.backgrounds.delete(self)
  end

  private

  def position_in_camera
    @position - Camera.main.position
  end

  # Camera relative Tiles
  # rubocop:disable Metrics/AbcSize
  def draw_repeat
    # TODO: optimize this. Looks to me that we are rendering more copies of the image
    #   than we need. Also if the camera is very far away from the Background
    #   we should only draw the images that will be shown in the screen

    tiles_delta_x = position_in_camera.x
    tiles_delta_y = position_in_camera.y

    tiles_needed_horizontal = 1
    tiles_needed_vertical = 1

    if repeat_horizontally?
      tiles_needed_horizontal = ((Global.screen_width - (tiles_delta_x + width)) / width.to_f).ceil + 2
      tiles_delta_x = (position_in_camera.x % width) - width
    end

    if repeat_vertically?
      tiles_needed_vertical = ((Global.screen_height - (tiles_delta_y + height)) / height.to_f).ceil + 2
      tiles_delta_y = (position_in_camera.y % height) - height
    end

    tiles_needed_horizontal.times do |index_horizontal|
      tiles_needed_vertical.times do |index_vertical|
        drawing_position =
          Coordinates.new(
            tiles_delta_x + (width * index_horizontal),
            tiles_delta_y + (height * index_vertical)
          )
        @image.draw(x: drawing_position.x, y: drawing_position.y, scale: @scale)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def draw_normal
    @image.draw(x: position_in_camera.x, y: position_in_camera.y, scale: @scale)
  end

  def repeat_horizontally?
    [:both, :horizontal, true].include?(@repeat)
  end

  def repeat_vertically?
    [:both, :vertical, true].include?(@repeat)
  end
end
