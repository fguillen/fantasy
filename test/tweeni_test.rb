# frozen_string_literal: true

require "test_helper"

class ActorTest < Minitest::Test
  def setup
    Global.game_proc = proc {}
    Global.game = Game.new(100, 100)
  end

  def test_tweeni
    Global.expects(:seconds_in_scene).at_least_once.returns(0)

    num = 0
    tween =
      Tweeni.start(from: 0, to: 10, seconds: 1) do |value|
        num = value
      end

    Global.expects(:seconds_in_scene).at_least_once.returns(0.1)
    tween.update
    assert_equal(1, num)

    Global.expects(:seconds_in_scene).at_least_once.returns(0.5)
    tween.update
    assert_equal(5, num)

    Global.expects(:seconds_in_scene).at_least_once.returns(1)
    tween.update
    assert_equal(10, num)
  end

  def test_on_finished_on_constructor
    state = "STARTED"
    proc = proc { state = "ENDED" }

    Global.expects(:seconds_in_scene).at_least_once.returns(0)
    tween = Tweeni.start(from: 0, to: 10, seconds: 1, on_finished: proc) {}

    Global.expects(:seconds_in_scene).at_least_once.returns(1.1)
    tween.update
    assert_equal("ENDED", state)
  end

  def test_on_finished_on_method
    state = "STARTED"

    Global.expects(:seconds_in_scene).at_least_once.returns(0)
    tween = Tweeni.start(from: 0, to: 10, seconds: 1) {}
    tween.on_finished do
      state = "ENDED"
    end

    Global.expects(:seconds_in_scene).at_least_once.returns(1.1)
    tween.update
    assert_equal("ENDED", state)
  end
end
