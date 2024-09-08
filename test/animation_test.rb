# frozen_string_literal: true

# write tests for the class `Animation`

require "test_helper"

class AnimationTest < Minitest::Test
  def setup
    Global.game_proc = Proc.new {}
    Global.game = Game.new(100, 100)
  end

  def test_validations
    assert_raises(ArgumentError) { Animation.new }
    assert_raises(ArgumentError) { Animation.new(names: ["apple_1"], sequence: "apple_sequence") }
    assert_raises(ArgumentError) { Animation.new(sequence: "apple_sequence") }
    assert_raises(ArgumentError) { Animation.new(names: ["apple_1"], columns: 1) }
    assert_raises(ArgumentError) { Animation.new(names: ["apple_1"], rows: 1) }
  end

  def test_default_values_sequence
    animation = Animation.new(sequence: "apple_sequence", columns: 17)
    assert_equal(17, animation.length)
    assert_equal(32, animation.width)
    assert_equal(32, animation.height)
    assert_equal(0, animation.frame)
    assert_equal(10, animation.speed)
  end

  def test_default_values_names
    animation = Animation.new(names: ["apple_1", "apple_2", "apple_3"])
    assert_equal(3, animation.length)
    assert_equal(32, animation.width)
    assert_equal(32, animation.height)
    assert_equal(0, animation.frame)
    assert_equal(10, animation.speed)
  end

  def test_name_when_names
    animation = Animation.new(names: ["apple_1", "apple_2", "apple_3"])
    assert_equal("apple_1", animation.name)
  end

  def test_name_when_sequence
    animation = Animation.new(sequence: "apple_sequence", columns: 17)
    assert_equal("apple_sequence", animation.name)
  end

  def test_update_when_speed_is_1
    Global.stubs(:seconds_in_scene).returns(0)
    animation = Animation.new(names: ["apple_1", "apple_2", "apple_3"], speed: 1)
    assert_equal(1, animation.speed)
    assert_equal(0, animation.frame)

    animation.update
    assert_equal(0, animation.frame)

    Global.stubs(:seconds_in_scene).returns(0.5)
    animation.update
    assert_equal(0, animation.frame)

    Global.stubs(:seconds_in_scene).returns(1)
    animation.update
    assert_equal(1, animation.frame)

    Global.stubs(:seconds_in_scene).returns(11)
    animation.update
    assert_equal(2, animation.frame)
  end

  def test_update_when_speed_is_10
    Global.stubs(:seconds_in_scene).returns(0)
    animation = Animation.new(names: ["apple_1", "apple_2", "apple_3"], speed: 10)
    assert_equal(10, animation.speed)
    assert_equal(0, animation.frame)

    animation.update
    assert_equal(0, animation.frame)

    Global.stubs(:seconds_in_scene).returns(0.5)
    animation.update
    assert_equal(2, animation.frame)

    Global.stubs(:seconds_in_scene).returns(1)
    animation.update
    assert_equal(1, animation.frame)

    Global.stubs(:seconds_in_scene).returns(1.1)
    animation.update
    assert_equal(2, animation.frame)

    Global.stubs(:seconds_in_scene).returns(1.21)
    animation.update
    assert_equal(0, animation.frame)
  end

  def test_draw
    animation = Animation.new(names: ["apple_1", "apple_2", "apple_3"])

    Image.any_instance.expects(:draw).with(x: "X", y: "Y", scale: "SCALE", rotation: "ROTATION", flip: "FLIP")

    animation.draw(x: "X", y: "Y", scale: "SCALE", rotation: "ROTATION", flip: "FLIP")
  end
end
