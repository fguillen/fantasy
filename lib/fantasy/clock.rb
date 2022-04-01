# frozen_string_literal: true

class Clock
  attr_accessor :persistent
  attr_reader :thread

  def initialize(&block)
    @block = block
    @thread = nil
    @persistent = false # if persistent, clock is not stopped when loading new scene

    Global.clocks << self
  end

  def run_now
    @thread =
      Thread.new do
        @block.call
      end
  end

  def run_on(seconds:)
    @thread =
      Thread.new do
        sleep(seconds)
        @block.call
      end
  end

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

  def stop
    Thread.kill(@thread) unless @thread.nil?
  end

  def started?
    !@thread.nil?
  end

  def persistent?
    @persistent
  end
end
