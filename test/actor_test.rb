# frozen_string_literal: true

require "test_helper"

SCREEN_WIDTH = 10
SCREEN_HEIGHT = 10

on_game do
end

class ActorTest < Minitest::Test
  def setup
    Global.game = Game.new
    Global.initialize
    @actor = Actor.new("player")
  end

  # Attributes :: INI
  def test_default_values
    assert_equal(Coordinates.zero, @actor.position)
    assert_equal(Coordinates.zero, @actor.direction)
    assert_equal(0, @actor.speed)
    assert_equal(0, @actor.jump_force)
    assert_equal(0, @actor.gravity)
    assert_equal(true, @actor.solid)
    assert_equal(1, @actor.scale)
    assert_equal("player", @actor.name)
    assert_equal(0, @actor.layer)
    assert_equal("all", @actor.collision_with)
  end

  def test_change_position
    @actor.position = Coordinates.new(1, 2)
    assert_equal(1, @actor.position.x)
    assert_equal(2, @actor.position.y)
  end

  def test_change_direction
    @actor.direction = Coordinates.new(1, 2)
    # Direction is normalized
    assert_in_delta(0.4, @actor.direction.x, 0.1)
    assert_in_delta(0.8, @actor.direction.y, 0.1)
  end

  def test_change_speed
    @actor.speed = 10
    assert_equal(10, @actor.speed)
  end

  def test_change_jump_force
    @actor.jump_force = 10
    assert_equal(10, @actor.jump_force)
  end

  def test_change_gravity
    @actor.gravity = 10
    assert_equal(10, @actor.gravity)
  end

  def test_change_solid
    @actor.solid = false
    refute(@actor.solid)
  end

  def test_change_scale
    @actor.scale = 10
    assert_equal(10, @actor.scale)
  end

  def test_change_name
    @actor.name = "other_name"
    assert_equal("other_name", @actor.name)
  end

  def test_change_layer
    @actor.layer = 10
    assert_equal(10, @actor.layer)
  end

  def test_change_collision_with
    @actor.collision_with = ["enemy"]
    assert_equal(["enemy"], @actor.collision_with)
  end
  # Attributes :: END

  # Move :: INI
  def test_move_when_speed_is_zero
    @actor.position = Coordinates.zero
    @actor.direction = Coordinates.right
    @actor.speed = 0

    @actor.move

    assert_equal(Coordinates.zero, @actor.position)
  end

  def test_move_when_direction_is_zero
    @actor.position = Coordinates.zero
    @actor.direction = Coordinates.zero
    @actor.speed = 10

    @actor.move

    assert_equal(Coordinates.zero, @actor.position)
  end

  def test_move_when_direction_and_speed_are_not_zero
    @actor.position = Coordinates.zero
    @actor.direction = Coordinates.right
    @actor.speed = 10

    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(10, @actor.position.x)
    assert_equal(0, @actor.position.y)
  end
  # Move :: INI

  # Callbacks :: INI
  def test_trigger_on_after_move_block
    value = 0

    @actor.on_after_move do
      value = 1
    end

    @actor.move

    assert_equal(1, value)
  end

  def test_trigger_on_after_move_do_method
    @actor.expects(:on_after_move_do)
    @actor.move
  end
  # Callbacks :: INI
end
