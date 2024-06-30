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
  # @param seconds [Number] the amount of seconds to wait after each execution
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
