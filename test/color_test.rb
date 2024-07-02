# frozen_string_literal: true

require "test_helper"

class ColorTest < Minitest::Test
  def test_default_values
    color = Color.new(r: 255, g: 10, b: 12)
    assert_equal(255, color.r)
    assert_equal(10, color.g)
    assert_equal(12, color.b)
    assert_equal(255, color.a)
    assert_nil(color.name)
  end

  def test_hex
    color = Color.new(r: 255, g: 10, b: 12)
    assert_equal("ff0a0c", color.hex)
  end

  def test_to_s
    color = Color.new(r: 255, g: 10, b: 12)
    assert_equal("r:255, g:10, b:12, a:255, hex:ff0a0c", color.to_s)
  end

  def test_get_color_from_palette
    color = Color.palette.rosy_brown
    assert_equal(188, color.r)
    assert_equal(143, color.g)
    assert_equal(143, color.b)
    assert_equal(255, color.a)
    assert_equal("rosy_brown", color.name)
  end
end
