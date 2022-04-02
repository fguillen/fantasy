# frozen_string_literal: true

require "test_helper"

class BackgroundTest < Minitest::Test
  def setup
    Global.initialize(16, 16)
    Camera.initialize
    @background = Background.new(image_name: "player")
  end

  # Attributes :: INI
  def test_default_values
    assert_equal(Coordinates.zero, @background.position)
    assert_equal(1, @background.scale)
    assert(@background.visible)
    assert_equal(-100, @background.layer)
    assert_equal(true, @background.replicable)
  end

  def test_change_position
    @background.position = Coordinates.new(1, 2)
    assert_equal(1, @background.position.x)
    assert_equal(2, @background.position.y)
  end

  def test_change_scale
    @background.scale = 10
    assert_equal(10, @background.scale)
  end

  def test_change_layer
    @background.layer = 10
    assert_equal(10, @background.layer)
  end

  def test_change_visible
    @background.visible = false
    refute(@background.visible)
  end

  def test_change_replicable
    @background.replicable = false
    refute(@background.replicable)
  end
  # Attributes :: END

  # Helper methods :: INI
  def test_width
    assert_equal(8, @background.width)

    @background.scale = 2
    assert_equal(16, @background.width)
  end

  def test_height
    assert_equal(8, @background.height)

    @background.scale = 2
    assert_equal(16, @background.height)
  end
  # Helper methods :: END

  def test_destroy
    Global.backgrounds.expects(:delete).with(@background)
    @background.destroy
  end

  def test_draw_replicable
    @background.scale = 2
    Global.instance_variable_set("@screen_width", 16)
    Global.instance_variable_set("@screen_height", 16)

    image = @background.instance_variable_get("@image")

    image.expects(:draw).with(x: -16, y: -16, scale: 2)
    image.expects(:draw).with(x: 0, y: -16, scale: 2)
    image.expects(:draw).with(x: -16, y: 0, scale: 2)
    image.expects(:draw).with(x: 0, y: 0, scale: 2)

    @background.draw
  end

  def test_draw_replicable_when_camera_moves
    @background.scale = 2
    Global.instance_variable_set("@screen_width", 16)
    Global.instance_variable_set("@screen_height", 16)

    image = @background.instance_variable_get("@image")

    Camera.main.position = Coordinates.new(20, 100)

    image.expects(:draw).with(x: -4, y: -4, scale: 2)
    image.expects(:draw).with(x: -4, y: 12, scale: 2)
    image.expects(:draw).with(x: 12, y: -4, scale: 2)
    image.expects(:draw).with(x: 12, y: 12, scale: 2)

    @background.draw
  end
end
