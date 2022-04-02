# frozen_string_literal: true

require "test_helper"

class CameraTest < Minitest::Test
  def test_position_default_value
    camera = Camera.new
    assert_equal(Coordinates.zero, camera.position)
  end

  def test_change_position
    camera = Camera.new
    camera.position = Coordinates.new(1, 2)
    assert_equal(1, camera.position.x)
    assert_equal(2, camera.position.y)
  end

  def test_direction_default_value
    camera = Camera.new
    assert_equal(Coordinates.zero, camera.direction)
  end

  def test_change_direction
    camera = Camera.new
    camera.direction = Coordinates.new(1, 2)
    assert_equal(1, camera.direction.x)
    assert_equal(2, camera.direction.y)
  end

  def test_speed_default_value
    camera = Camera.new
    assert_equal(0, camera.speed)
  end

  def test_change_speed
    camera = Camera.new
    camera.speed = 10
    assert_equal(10, camera.speed)
  end

  def test_move_when_speed_is_zero
    camera = Camera.new
    camera.position = Coordinates.zero
    camera.direction = Coordinates.right
    camera.speed = 0

    camera.move

    assert_equal(Coordinates.zero, camera.position)
  end

  def test_move_when_direction_is_zero
    camera = Camera.new
    camera.position = Coordinates.zero
    camera.direction = Coordinates.zero
    camera.speed = 10

    camera.move

    assert_equal(Coordinates.zero, camera.position)
  end

  def test_move_when_direction_and_speed_are_not_zero
    camera = Camera.new
    camera.position = Coordinates.zero
    camera.direction = Coordinates.right
    camera.speed = 10

    Global.expects(:frame_time).returns(1)

    camera.move

    assert_equal(10, camera.position.x)
    assert_equal(0, camera.position.y)
  end

  def test_trigger_on_after_move_block
    value = 0

    camera = Camera.new
    camera.on_after_move do
      value = 1
    end

    camera.move

    assert_equal(1, value)
  end

  def test_initialize_main_camera
    Camera.initialize
    assert_instance_of(Camera, Camera.main)
  end

  def test_reset
    Camera.initialize
    old_camera = Camera.main

    Camera.reset

    assert_instance_of(Camera, Camera.main)
    refute_equal(old_camera, Camera.main)
  end
end
