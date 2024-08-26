# frozen_string_literal: true

require "test_helper"

class ActorTest < Minitest::Test
  def setup
    Global.game_proc = Proc.new {}
    Global.game = Game.new(100, 100)
  end

  def test_tweeni
    Global.expects(:seconds_in_scene).returns(0)

    num = 0
    tween =
      Tweeni.start(from: 0, to: 10, seconds: 1) do |value|
        num = value
      end

    Global.expects(:seconds_in_scene).returns(0.1)
    tween.update
    assert_equal(1, num)

    Global.expects(:seconds_in_scene).returns(0.5)
    tween.update
    assert_equal(6, num)

    Global.expects(:seconds_in_scene).returns(1)
    tween.update
    assert_equal(10, num)
  end

  def test_on_end
    state = "STARTED"
    proc = Proc.new { state = "ENDED" }

    tween = Tweeni.start(from: 0, to: 10, seconds: 1, on_end: proc) {}

    Global.expects(:seconds_in_scene).returns(2)
    tween.update
    assert_equal("ENDED", state)
  end
end
