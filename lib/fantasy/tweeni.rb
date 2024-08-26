# frozen_string_literal: true

require "tween"

# frozen_string_literal: true

# Represents a Tween transition. It modify
# a number from one value to another. It can be used
# to create animation effects.
#
# For example, when moving an actor from one position to another
# it can be used to create a smooth movement. That has some quality
# of bouncinness, smoothness and easing.
#
#
# @example Move an actor to the right 100 pixels in 1 second
#          First moving slow and then fast close to the end
#          of the movement.
#   player = Actor.new("warrior")
#   player.position = Coordinates.new(0, 100)
#   tween =
#     Tweeni.start(from: 0, to: 100, seconds: 1, ease: Circ::In) do |value|
#       player.position.x = value
#     end
#
# Attetion: the collisions won't be detected if you use tween to move an actor
#
# @example Make Background increase in size in 0.5 seconds
#          and bounce at the end. At the end wait 1 second and back
#          to the original size:
#  background = Background.new("background")
#  tween =
#    Tweeni.start(from: 1, to: 1.8, seconds: 0.5, ease: Elastic::Out) do |value|
#      background.scale = value
#    end
#  tween.on_end do
#    sleep(1)
#    tween = Tweeni.start(from: 1.8, to: 1, seconds: 0.5, ease: Linear) do |value|
#      background.scale = value
#    end
#  end
class Tweeni
  # The full list of available easers
  EASERS = [
    Linear,

    Sine::In,
    Sine::Out,
    Sine::InOut,

    Circ::In,
    Circ::Out,
    Circ::InOut,

    Bounce::Out,
    Bounce::In,
    Bounce::InOut,

    Back::In,
    Back::Out,
    Back::InOut,

    Cubic::In,
    Cubic::Out,
    Cubic::InOut,

    Expo::In,
    Expo::Out,
    Expo::InOut,

    Quad::In,
    Quad::Out,
    Quad::InOut,

    Quart::In,
    Quart::Out,
    Quart::InOut,

    Quint::In,
    Quint::Out,
    Quint::InOut,

    Elastic::In,
    Elastic::Out
  ]

  # @return [Boolean] true if the tween is already finished.
  attr_reader :finished

  class << self
    # Creates a new Tweeni instance
    #
    # @param from [Number] the initial value
    # @param to [Number] the final value
    # @param seconds [Number] the time in seconds
    # @param ease [Function] the easing function @see EASERS. Default `Linear`
    # @param on_end [Proc] the block to be executed when the tween ends. Default `nil`
    # @param block [Proc] the block to be executed during the tween
    # @return [Tweeni]
    def start(from:, to:, seconds:, ease: Tween::Linear, on_end: nil, &block)
      Tweeni.new(from:, to:, seconds:, ease:, on_end:, &block)
    end
  end

  # @!visibility private
  def initialize(from:, to:, seconds:, ease: Tween::Linear, on_end: nil, &block)
    @from = from
    @to = to
    @seconds = seconds
    @ease = ease
    @block = block
    @on_end = on_end
    @finished = false

    @init_at = Global.seconds_in_scene
    @tween = Tween.new(@from, @to, @ease, @seconds)

    Global.tweens&.push(self)
  end

  # @!visibility private
  def update
    @tween.update(Global.seconds_in_scene - @init_at)
    @block.call(@tween.value)

    if(@tween.done)
      Global.tweens.delete(self)
      @finished = true
      @on_end.call if @on_end
    end
  end

  # Set a block to be executed when the tween ends
  #
  # @param block [Proc] the block to be executed when the tween ends
  #
  # @example Set a block to be executed when the tween ends
  #   tween.on_end do
  #     puts "The tween has ended"
  #   end
  def on_end(&block)
    @on_end = block
  end
end
