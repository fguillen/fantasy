# frozen_string_literal: true

require "test_helper"

class IndexableTest < Minitest::Test
  def setup
    Indexable.last_creation_index = 0
  end

  def test_actor_is_indexable
    actor_1 = Actor.new("player")
    assert_equal(1, actor_1.creation_index)

    actor_2 = Actor.new("player")
    assert_equal(2, actor_2.creation_index)
  end

  def test_different_classes_are_indexable
    background = Background.new(image_name: "white_pixel")
    assert_equal(1, background.creation_index)

    actor_1 = Actor.new("player")
    assert_equal(2, actor_1.creation_index)

    hud_text = HudText.new
    assert_equal(3, hud_text.creation_index)

    hud_image = HudImage.new(image_name: "white_pixel")
    assert_equal(4, hud_image.creation_index)

    tile_map = Tilemap.new(map_name: "tile_map", tiles: [], tile_size: 1)
    assert_equal(5, tile_map.creation_index)

    shape = Shape.new
    assert_equal(6, shape.creation_index)
  end
end
