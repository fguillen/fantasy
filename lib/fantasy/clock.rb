# frozen_string_literal: true

# Encapsulates a block that will executed in an independent thread.
# Can be executed imediately or executed after a certain amount of time.
# Also supports repeating executions.
#
# @example Frog jumps after 1 second
#   Clock.new { frog.jump }.run_on(seconds: 1)
#
# @example Flower opens and closes every 2 seconds for 5 times
#   clock =
#     Clock.new do
#       flower.open
#       flower.close
#     end
#   clock.repeat(seconds: 2, times: 5)
#
# @example Window opens slowly
#   clock =
#     Clock.new do
#       while !window.totally_open
#         window.open_a_bit
#       end
#     end
#   clock.run_now
# @example a Monster with many eyes each of them blinking at different time. Get the full code and the assets here: https://github.com/fguillen/RubyInFantasyGames/tree/main/PinkMonster
#   on_game do
#     Global.background = Color.palette.peach_puff
#     body = Actor.new("body")
#     body.position = Coordinates.new(90, 10)
#
#     smile = Actor.new("smile")
#     smile.position = Coordinates.new(110, 140)
#     # smile will rotate 180 degrees every half of a second
#     Clock.new { smile.rotation += 180 }.repeat(seconds: 0.5)
#
#     eye_1 = Actor.new("eye_open")
#     eye_1.position = Coordinates.new(120, 80)
#     # this eye will blink every 2 seconds
#     Clock.new { blink(eye_1) }.repeat(seconds: 2)
#
#     eye_2 = Actor.new("eye_open")
#     eye_2.position = Coordinates.new(120, 200)
#     # this eye will blink only once right now
#     Clock.new { blink(eye_2) }.run_now
#
#     eye_3 = Actor.new("eye_open")
#     eye_3.position = Coordinates.new(120, 280)
#     # this eye will be closed in 10 senconds
#     Clock.new { eye_3.image = "eye_closed" }.run_on(seconds: 10)
#
#     eye_4 = Actor.new("eye_open")
#     eye_4.position = Coordinates.new(120, 350)
#     # this eye will blink every 1 to 4 seconds
#     Clock.new { blink(eye_4) }.repeat(seconds: 1..4)
#
#     eye_5 = Actor.new("eye_open")
#     eye_5.position = Coordinates.new(120, 440)
#     # this eye will blink every 1 to 4 seconds
#     Clock.new { blink(eye_5) }.repeat(seconds: 1..4)
#
#     eye_6 = Actor.new("eye_open")
#     eye_6.position = Coordinates.new(120, 505)
#     # this eye will blink every 1 to 4 seconds
#     Clock.new { blink(eye_6) }.repeat(seconds: 1..4)
#   end
#
#   def blink(eye)
#     eye.image = "eye_closed"
#     sleep(0.3)
#     eye.image = "eye_open"
#   end
#
#   start!
class Clock
  # If `true`, clock is not stopped when loading new scene
  #
  # Default `false`.
  #
  # @return [bool] The value of persistent
  #
  # @example Sound keeps repeating even when changing scenes
  #   clock = Clock.new { Sound.play("click") }
  #   clock.repeat
  #   clock.persistent = true
  #   Global.go_to_end
  attr_accessor :persistent

  # Whenever the clock is started, the block is executed in a new thread.
  # The thread reference is stored in `@thread`
  #
  # Default `nil`.
  #
  # @return [Thread] the thread that executes the block
  attr_reader :thread

  # Generate a Clock with all defaults. The Clock won't run until invoked.
  # @example Generate a Clock
  #   clock = Clock.new { puts "I'm a clock" }
  #   clock.persistent # => false
  #   clock.thread # => nil
  #
  # @param block [Proc] the block to be exectued in a new thread
  # @return [Clock] the Clock reference
  def initialize(&block)
    @block = block
    @thread = nil
    @persistent = false # if persistent, clock is not stopped when loading new scene

    Global.clocks << self
  end

  # Executes the clock's block in an independent thread.
  # @example
  #   clock.run_now
  def run_now
    @thread =
      Thread.new do
        @block.call
      end
  end

  # Executes the clock's block in an independent thread after a certain amount of `seconds`.
  # @example The clock will be triggered after 2 seconds
  #   clock.run_on(seconds: 2)
  # @example The clock will be triggered after 100 milliseconds
  #   clock.run_on(seconds: 0.1)
  # @example The clock will be triggered after random amount of seconds between 1 and 10
  #   clock.run_on(seconds: rand(1..10))
  # @param seconds [Number] the amount of seconds to wait before the block is executed
  def run_on(seconds:)
    @thread =
      Thread.new do
        sleep(seconds)
        @block.call
      end
  end

  # Executes the clock's block in an independent thread.
  # and repeats the execution every certain amount of `seconds` for a certain amount of `times`.
  #
  # @example The clock will be repeated every 2 seconds for 5 times
  #   clock.repeat(seconds: 2, times: 5)
  # @example The clock will be repeated every randome amount of seconds between 1 and 10, Infinity times.
  #   clock.repeat(seconds: 1..10)
  # @param seconds [Number | Range] the amount of seconds to wait after each execution.
  # If a Ranged is passed. A random number between the range will be evaluated every iteration and used to wait for the next iteration.
  # @param times [Integer] the amount of times to repeat the execution
  def repeat(seconds: 1, times: Float::INFINITY)
    times_executed = 0
    @thread =
      Thread.new do
        while times_executed < times
          @block.call
          times_executed += 1

          seconds_to_sleep = seconds.is_a?(Range) ? rand(seconds) : seconds
          sleep(seconds_to_sleep)
        end
      end
  end

  # Stops the clock. The thread will be killed.
  #
  # @example The clock is stopped. And triggered again
  #   clock.stops
  #   # More code here
  #   clock.run_now
  def stop
    Thread.kill(@thread) unless @thread.nil?
  end

  # @return [bool] `true` if the clock has been triggered.
  def started?
    !@thread.nil?
  end

  # @return [bool] the value of `@persistent`
  def persistent?
    @persistent
  end
end
