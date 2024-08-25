# frozen_string_literal: true

require "test_helper"

class ActorTest < Minitest::Test
  def setup
    Global.game_proc = Proc.new {}
    Global.game = Game.new(100, 100)
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
    assert_equal("none", @actor.collision_with)
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

  def test_change_collision_none
    @actor.collision_with = "none"
    assert_equal("none", @actor.collision_with)
  end

  def test_change_collision_all
    @actor.collision_with = "all"
    assert_equal("all", @actor.collision_with)
  end

  def test_change_collision_with
    @actor.collision_with = ["enemy"]
    assert_equal(["enemy"], @actor.collision_with)
  end

  def test_change_collision_with_using_shortcut
    @actor.collision_with = "enemy"
    assert_equal(["enemy"], @actor.collision_with)
  end
  # Attributes :: END

  # Helper methods :: INI
  def test_width
    assert_equal(8, @actor.width)

    @actor.scale = 2
    assert_equal(16, @actor.width)
  end

  def test_height
    assert_equal(8, @actor.height)

    @actor.scale = 2
    assert_equal(16, @actor.height)
  end

  def test_solid_question_mark
    assert(@actor.solid?)

    @actor.solid = false
    refute(@actor.solid?)
  end

  def test_image_setter
    old_sprite = @actor.instance_variable_get("@sprite")
    @actor.sprite = "zombie"
    assert_instance_of(Image, @actor.instance_variable_get("@sprite"))
    refute_equal(old_sprite, @actor.instance_variable_get("@sprite"))
  end
  # Helper methods :: END

  def test_destroy
    Global.actors.expects(:delete).with(@actor)
    @actor.destroy
  end

  def test_clone
    @actor.name = "NAME"
    @actor.position = "POSITION"
    @actor.direction = Coordinates.new(1, 0)

    @actor.speed = "SPEED"
    @actor.scale = "SCALE"
    @actor.solid = "SOLID"
    @actor.layer = "LAYER"
    @actor.gravity = "GRAVITY"
    @actor.jump_force = "JUMP_FORCE"
    @actor.collision_with = "COLLISION_WITH"

    @actor.instance_variable_set("@on_after_move_callback", "ON_AFTER_MOVE_CALLBACK")
    @actor.instance_variable_set("@on_collision_callback", "ON_COLLISION_CALLBACK")
    @actor.instance_variable_set("@on_destroy_callback", "ON_DESTROY_CALLBACK")
    @actor.instance_variable_set("@on_jumping_callback", "ON_JUMPING_CALLBACK")
    @actor.instance_variable_set("@on_floor_callback", "ON_FLOOR_CALLBACK")

    @actor.instance_variable_set("@on_cursor_down_callback", "ON_CURSOR_DOWN_CALLBACK")
    @actor.instance_variable_set("@on_cursor_up_callback", "ON_CURSOR_UP_CALLBACK")
    @actor.instance_variable_set("@on_cursor_left_callback", "ON_CURSOR_LEFT_CALLBACK")
    @actor.instance_variable_set("@on_cursor_right_callback", "ON_CURSOR_RIGHT_CALLBACK")
    @actor.instance_variable_set("@on_space_bar_callback", "ON_SPACE_BAR_CALLBACK")
    @actor.instance_variable_set("@on_mouse_button_left_callback", "ON_MOUSE_BUTTON_LEFT_CALLBACK")

    @actor.instance_variable_set("@on_click_callback", "ON_CLICK_CALLBACK")

    other_actor = @actor.clone

    assert_equal("NAME", other_actor.name)
    assert_equal("POSITION", other_actor.position)
    assert_equal(Coordinates.new(1, 0), other_actor.direction)

    assert_equal("SPEED", other_actor.speed)
    assert_equal("SCALE", other_actor.scale)
    assert_equal("SOLID", other_actor.solid)
    assert_equal("LAYER", other_actor.layer)
    assert_equal("GRAVITY", other_actor.gravity)
    assert_equal("JUMP_FORCE", other_actor.jump_force)
    assert_equal(["COLLISION_WITH"], other_actor.collision_with)

    assert_equal("ON_AFTER_MOVE_CALLBACK", other_actor.instance_variable_get("@on_after_move_callback"))
    assert_equal("ON_COLLISION_CALLBACK", other_actor.instance_variable_get("@on_collision_callback"))
    assert_equal("ON_DESTROY_CALLBACK", other_actor.instance_variable_get("@on_destroy_callback"))
    assert_equal("ON_JUMPING_CALLBACK", other_actor.instance_variable_get("@on_jumping_callback"))
    assert_equal("ON_FLOOR_CALLBACK", other_actor.instance_variable_get("@on_floor_callback"))

    assert_equal("ON_CURSOR_DOWN_CALLBACK", other_actor.instance_variable_get("@on_cursor_down_callback"))
    assert_equal("ON_CURSOR_UP_CALLBACK", other_actor.instance_variable_get("@on_cursor_up_callback"))
    assert_equal("ON_CURSOR_LEFT_CALLBACK", other_actor.instance_variable_get("@on_cursor_left_callback"))
    assert_equal("ON_CURSOR_RIGHT_CALLBACK", other_actor.instance_variable_get("@on_cursor_right_callback"))
    assert_equal("ON_SPACE_BAR_CALLBACK", other_actor.instance_variable_get("@on_space_bar_callback"))
    assert_equal("ON_MOUSE_BUTTON_LEFT_CALLBACK", other_actor.instance_variable_get("@on_mouse_button_left_callback"))
  end

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

  def test_move_when_gravity
    @actor.gravity = 10
    @actor.speed = 100
    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(0, @actor.position.x)
    assert_equal(10, @actor.position.y)
  end

  def test_move_with_cursors_down
    @actor.move_with_cursors
    @actor.speed = 10

    Gosu.stubs(:button_down?)
    Gosu.expects(:button_down?).with(Cursor.down).returns(true)
    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(0, @actor.position.x)
    assert_equal(10, @actor.position.y)
  end

  def test_move_with_cursors_up
    @actor.move_with_cursors
    @actor.speed = 10

    Gosu.stubs(:button_down?)
    Gosu.expects(:button_down?).with(Cursor.up).returns(true)
    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(0, @actor.position.x)
    assert_equal(-10, @actor.position.y)
  end

  def test_move_with_cursors_left
    @actor.move_with_cursors
    @actor.speed = 10

    Gosu.stubs(:button_down?)
    Gosu.expects(:button_down?).with(Cursor.left).returns(true)
    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(-10, @actor.position.x)
    assert_equal(0, @actor.position.y)
  end

  def test_move_with_cursors_right
    @actor.move_with_cursors
    @actor.speed = 10

    Gosu.stubs(:button_down?)
    Gosu.expects(:button_down?).with(Cursor.right).returns(true)
    Global.expects(:frame_time).returns(1)

    @actor.move

    assert_equal(10, @actor.position.x)
    assert_equal(0, @actor.position.y)
  end

  def test_move_with_cursors_up_right
    @actor.move_with_cursors
    @actor.speed = 10

    Gosu.stubs(:button_down?)
    Gosu.expects(:button_down?).with(Cursor.up).returns(true)
    Gosu.expects(:button_down?).with(Cursor.right).returns(true)
    Global.expects(:frame_time).returns(1).at_least_once

    @actor.move

    assert_equal(7.07, @actor.position.x.round(2))
    assert_equal(-7.07, @actor.position.y.round(2))
  end

  def test_move_with_impulse
    Global.expects(:frame_time).returns(1).at_least_once

    @actor.impulse(direction: Coordinates.right, force: 10)
    @actor.move
    assert_equal(10, @actor.position.x)
    assert_equal(0, @actor.position.y)

    @actor.impulse(direction: Coordinates.up, force: 1)
    @actor.move
    assert_equal(20, @actor.position.x)
    assert_equal(-1, @actor.position.y)
  end

  def test_move_with_jump
    Global.expects(:frame_time).returns(1).at_least_once

    # When jump_force is zero
    @actor.jump_force = 0
    @actor.jump
    @actor.move
    assert_equal(0, @actor.position.x)
    assert_equal(0, @actor.position.y)

    # When jump_force is not zero
    @actor.jump_force = 1
    @actor.jump
    @actor.move
    assert_equal(0, @actor.position.x)
    assert_equal(-1, @actor.position.y)
  end
  # Move :: INI


  # Collision :: INI
  def test_collision_after_moving_by_direction
    @actor.position = Coordinates.zero
    @actor.collision_with = "all"
    other_actor = Actor.new("player")
    other_actor.position = Coordinates.new(@actor.width, 0)

    collisions = []

    @actor.on_collision do |other|
      collisions.push(other)
    end

    Global.expects(:frame_time).returns(1).at_least_once

    # Direction is zero
    @actor.direction = Coordinates.zero
    @actor.speed = 1
    @actor.move
    assert_equal([], collisions)

    # Direction is right
    @actor.direction = Coordinates.right
    @actor.move
    assert_equal([other_actor], collisions)
    assert_equal(Coordinates.zero, @actor.position)
  end

  def test_collision_after_moving_by_cursor
    @actor.position = Coordinates.zero
    @actor.collision_with = "all"
    @actor.move_with_cursors
    other_actor = Actor.new("player")
    other_actor.position = Coordinates.new(@actor.width, 0)

    collisions = []

    @actor.on_collision do |other|
      collisions.push(other)
    end

    Gosu.stubs(:button_down?)
    Global.expects(:frame_time).returns(1).at_least_once

    # No cursor key pressed
    @actor.speed = 1
    @actor.move
    assert_equal([], collisions)

    # Cursor right key pressed
    Gosu.expects(:button_down?).with(Cursor.right).returns(true)
    @actor.move
    assert_equal([other_actor], collisions)
    assert_equal(Coordinates.zero, @actor.position)
  end

  def test_collision_after_gravity
    @actor.position = Coordinates.zero
    @actor.collision_with = "all"
    other_actor = Actor.new("player")
    other_actor.position = Coordinates.new(0, @actor.height)

    Global.expects(:frame_time).returns(1).at_least_once

    collisions = []
    on_floor = false

    @actor.on_collision do |other|
      collisions.push(other)
    end

    @actor.on_floor do
      on_floor = true
    end

    # Gravity is zero
    @actor.gravity = 0
    @actor.move
    assert_equal([], collisions)
    refute(on_floor)

    # Gravity is 1
    @actor.gravity = 1
    @actor.move
    assert_equal([other_actor], collisions)
    assert_equal(Coordinates.zero, @actor.position)
    assert(on_floor)
  end
  # Collision :: END


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

  def test_on_jumping_do_when_jump
    @actor.expects(:on_jumping_do)
    @actor.jump
  end

  def test_on_destroy_do_when_destroy
    @actor.expects(:on_destroy_do)
    @actor.destroy
  end

  def test_on_cursor_triggers
    gosu_game = Game.new(100, 100)

    actor = Actor.new("player")

    actor.expects(:on_cursor_down_do)
    gosu_game.button_down(Cursor.down)

    actor.expects(:on_cursor_up_do)
    gosu_game.button_down(Cursor.up)

    actor.expects(:on_cursor_left_do)
    gosu_game.button_down(Cursor.left)

    actor.expects(:on_cursor_right_do)
    gosu_game.button_down(Cursor.right)

    actor.expects(:on_space_bar_do)
    gosu_game.button_down(Cursor.space_bar)
  end

  def test_on_click_do
    gosu_game = Game.new(100, 100)
    gosu_game.expects(:mouse_x).returns(1)
    gosu_game.expects(:mouse_y).returns(1)

    actor = Actor.new("player")
    actor.expects(:on_click_do)
    gosu_game.button_down(Mouse.left)
  end

  def test_no_on_click_do_when_mouse_coordinates_are_not_in_actor
    gosu_game = Game.new(100, 100)
    gosu_game.expects(:mouse_x).returns(100)
    gosu_game.expects(:mouse_y).returns(1)

    actor = Actor.new("player")
    actor.expects(:on_click_do).never
    gosu_game.button_down(Mouse.left)
  end
  # Callbacks :: END

  def test_on_state_and_state
    jumping = false
    @actor.on_state(:jumping) do
      jumping = true
    end

    refute(jumping)
    @actor.state(:jumping)
    assert(jumping)
  end

  def test_raise_error_if_calling_not_existing_state
    assert_raises(ArgumentError) { @actor.state(:unknown) }
  end
end
