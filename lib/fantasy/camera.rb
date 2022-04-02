# frozen_string_literal: true

# Represents Coordinates of the camera and it affects the screen position of all Actors and Backgrounds.
# There is only one active Camera and it is acceded by `Camera.main`. This Camera is initialized automatically
# and it is already accessible. It can also be changed by another `Camera` instance.`
#
# @example Set the camera position
#   Camera.main.position = Coordinates.new(0, 100)
#
# @example Camera follows player vertically
#   on_game do
#     player = Actor.new("image")
#
#     on_loop do
#       Camera.main.position.y = player.position.y - (SCREEN_HEIGHT / 2)
#     end
#   end
#
# @example Switching between cameras
#   camera_1 = Camera.new
#   camera_2 = Camera.new(position: Coordinates.new(0, 10))
#   Camera.main = camera_1
#   Camera.main = camera_2
class Camera

  # Coordinates object where x and y represent the position of the Camera in the World (no necessarily in the Screen).
  #
  # Default `Coordinates.zero`.
  #
  # @return [Coordinates] the actual position
  #
  # @example Setting position
  #   Camera.main.position = Coordinates.new(10, 20)
  #   Camera.main.position.x # => 10
  #
  # @example Modify position
  #   Camera.main.position.x +=  1
  #   Camera.main.position.x # => 11
  attr_accessor :position

  # Controls the direction in which the Camera will move in the next frame.
  #
  # Default `Coordinates.zero`.
  #
  # @return [Coordinates] the actual direction
  #
  # @note The the pixels per second is represented by the `@speed` attribute
  #
  # @example Set direction
  #   Camera.main.direction = Coordinates.right
  attr_accessor :direction

  # Controls the pixels per second which the Camera will move in the next frame.
  #
  # Default `0`.
  #
  # @return [Float] the actual speed
  #
  # @note The the direction is represented by the `@direction` attribute
  #
  # @example Set speed
  #   Camera.main.speed = 10
  attr_accessor :speed

  # Generates a Camera with all the default attribute values
  # @example Generate an Camera
  #   camera = Camera.new
  #   camera.position # => Coordinates.zero
  #   camera.direction # => Coordinates.zero
  #   camera.speed # => 0
  #
  # @param position [Coordinates] the initial position of the camera. Default `Coordinates.zero`
  # @return [Camera] the Camera
  def initialize(position: Coordinates.zero)
    @position = position
    @direction = Coordinates.zero
    @speed = 0
    @on_after_move_callback = nil
  end

  # @!visibility private
  def move
    if @direction != Coordinates.zero && !@speed.zero?
      @position += (@direction * @speed * Global.frame_time)
    end

    @on_after_move_callback&.call
  end

  # Triggered on every frame after the move has been executed
  # @example Avoid Camera to move over limits
  #   Camera.main.on_after_move do
  #     if Camera.main.position.x > 100
  #       Camera.main.position.x = 100
  #     end
  #   end
  def on_after_move(&block)
    @on_after_move_callback = block
  end

  class << self
    # @return [Camera] The active Camera
    attr_accessor :main

    # @!visibility private
    def initialize
      reset
    end

    # @!visibility private
    def reset
      @main = Camera.new
    end
  end
end
