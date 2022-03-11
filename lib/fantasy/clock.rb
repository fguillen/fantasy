class Clock
  def initialize(&block)
    @block = block
    @thread = nil

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
        while(times_executed < times)
          @block.call
          times_executed += 1;
          sleep(seconds)
        end
      end
  end

  def stop
    Thread.kill(@thread)
  end
end
