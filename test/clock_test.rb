# frozen_string_literal: true

require "test_helper"

class ClockTest < Minitest::Test
  def setup
    Global.game_proc = Proc.new {}
    Global.game = Game.new(100, 100)
  end

  def test_default_values
    clock = Clock.new { "block" }
    assert_nil(clock.thread)
    refute(clock.persistent)
  end

  def test_when_created_is_automatically_added_to_global_clocks
    clock = Clock.new { "block" }
    assert_includes(Global.clocks, clock)
  end

  def test_run_now
    a = 0
    clock = Clock.new { a = 1 }
    clock.run_now
    clock.thread.join

    assert_equal(1, a)
  end

  def test_run_on
    a = 0
    clock = Clock.new { a = 1 }
    clock.run_on(seconds: 0.01)
    clock.thread.join

    assert_equal(1, a)
  end

  def test_repeat
    a = 0
    clock = Clock.new { a += 1 }
    clock.repeat(seconds: 0.01, times: 2)
    clock.thread.join

    assert_equal(2, a)
  end

  def test_persistent_question_mark
    clock = Clock.new { "block" }
    clock.persistent = true
    assert(clock.persistent?)
  end

  def test_started_question_mark
    clock = Clock.new { "block" }
    refute(clock.started?)
    clock.run_now
    assert(clock.started?)
  end

  # TODO: test_stop
  # TODO: test_when_persistent_is_true_the_clock_is_not_stopped_when_loading_new_scene
end
