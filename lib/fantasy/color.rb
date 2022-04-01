# frozen_string_literal: true

require "ostruct"

class Color < Gosu::Color
  attr_reader :a, :r, :g, :b, :name

  def initialize(r:, g:, b:, a: 255, name: nil)
    super(a, r, g, b)

    @a = a
    @r = r
    @g = g
    @b = b
    @name = name
  end

  def hex
    [@r, @g, @b].map do |e|
      e.to_s(16).rjust(2, "0")
    end.join
  end

  def to_s
    result = "r:#{@r}, g:#{@g}, b:#{@b}, a:#{@a}, hex:#{hex}"
    result += " (#{name})" unless name.nil?

    result
  end

  class << self
    attr_reader :palette
  end

  @palette =
    OpenStruct.new({
      "orange" => Color.new(r: 255, g: 165, b: 0, a: 255, name: "orange"),
      "red" => Color.new(r: 255, g: 0, b: 0, a: 255, name: "red"),
      "orange_red" => Color.new(r: 255, g: 69, b: 0, a: 255, name: "orange_red"),
      "tomato" => Color.new(r: 255, g: 99, b: 71, a: 255, name: "tomato"),
      "dark_red" => Color.new(r: 139, g: 0, b: 0, a: 255, name: "dark_red"),
      "fire_brick" => Color.new(r: 178, g: 34, b: 34, a: 255, name: "fire_brick"),
      "crimson" => Color.new(r: 220, g: 20, b: 60, a: 255, name: "crimson"),
      "deep_pink" => Color.new(r: 255, g: 20, b: 147, a: 255, name: "deep_pink"),
      "maroon" => Color.new(r: 176, g: 48, b: 96, a: 255, name: "maroon"),
      "indian_red" => Color.new(r: 205, g: 92, b: 92, a: 255, name: "indian_red"),
      "medium_violet_red" => Color.new(r: 199, g: 21, b: 133, a: 255, name: "medium_violet_red"),
      "violet_red" => Color.new(r: 208, g: 32, b: 144, a: 255, name: "violet_red"),
      "light_coral" => Color.new(r: 240, g: 128, b: 128, a: 255, name: "light_coral"),
      "hot_pink" => Color.new(r: 255, g: 105, b: 180, a: 255, name: "hot_pink"),
      "pale_violet_red" => Color.new(r: 219, g: 112, b: 147, a: 255, name: "pale_violet_red"),
      "light_pink" => Color.new(r: 255, g: 182, b: 193, a: 255, name: "light_pink"),
      "rosy_brown" => Color.new(r: 188, g: 143, b: 143, a: 255, name: "rosy_brown"),
      "pink" => Color.new(r: 255, g: 192, b: 203, a: 255, name: "pink"),
      "orchid" => Color.new(r: 218, g: 112, b: 214, a: 255, name: "orchid"),
      "lavender_blush" => Color.new(r: 255, g: 240, b: 245, a: 255, name: "lavender_blush"),
      "snow" => Color.new(r: 255, g: 250, b: 250, a: 255, name: "snow"),
      "chocolate" => Color.new(r: 210, g: 105, b: 30, a: 255, name: "chocolate"),
      "saddle_brown" => Color.new(r: 139, g: 69, b: 19, a: 255, name: "saddle_brown"),
      "brown" => Color.new(r: 132, g: 60, b: 36, a: 255, name: "brown"),
      "dark_orange" => Color.new(r: 255, g: 140, b: 0, a: 255, name: "dark_orange"),
      "coral" => Color.new(r: 255, g: 127, b: 80, a: 255, name: "coral"),
      "sienna" => Color.new(r: 160, g: 82, b: 45, a: 255, name: "sienna"),
      "salmon" => Color.new(r: 250, g: 128, b: 114, a: 255, name: "salmon"),
      "peru" => Color.new(r: 205, g: 133, b: 63, a: 255, name: "peru"),
      "dark_goldenrod" => Color.new(r: 184, g: 134, b: 11, a: 255, name: "dark_goldenrod"),
      "goldenrod" => Color.new(r: 218, g: 165, b: 32, a: 255, name: "goldenrod"),
      "sandy_brown" => Color.new(r: 244, g: 164, b: 96, a: 255, name: "sandy_brown"),
      "light_salmon" => Color.new(r: 255, g: 160, b: 122, a: 255, name: "light_salmon"),
      "dark_salmon" => Color.new(r: 233, g: 150, b: 122, a: 255, name: "dark_salmon"),
      "gold" => Color.new(r: 255, g: 215, b: 0, a: 255, name: "gold"),
      "yellow" => Color.new(r: 255, g: 255, b: 0, a: 255, name: "yellow"),
      "olive" => Color.new(r: 128, g: 128, b: 0, a: 255, name: "olive"),
      "burlywood" => Color.new(r: 222, g: 184, b: 135, a: 255, name: "burlywood"),
      "tan" => Color.new(r: 210, g: 180, b: 140, a: 255, name: "tan"),
      "navajo_white" => Color.new(r: 255, g: 222, b: 173, a: 255, name: "navajo_white"),
      "peach_puff" => Color.new(r: 255, g: 218, b: 185, a: 255, name: "peach_puff"),
      "khaki" => Color.new(r: 240, g: 230, b: 140, a: 255, name: "khaki"),
      "dark_khaki" => Color.new(r: 189, g: 183, b: 107, a: 255, name: "dark_khaki"),
      "moccasin" => Color.new(r: 255, g: 228, b: 181, a: 255, name: "moccasin"),
      "wheat" => Color.new(r: 245, g: 222, b: 179, a: 255, name: "wheat"),
      "bisque" => Color.new(r: 255, g: 228, b: 196, a: 255, name: "bisque"),
      "pale_goldenrod" => Color.new(r: 238, g: 232, b: 170, a: 255, name: "pale_goldenrod"),
      "blanched_almond" => Color.new(r: 255, g: 235, b: 205, a: 255, name: "blanched_almond"),
      "medium_goldenrod" => Color.new(r: 234, g: 234, b: 173, a: 255, name: "medium_goldenrod"),
      "papaya_whip" => Color.new(r: 255, g: 239, b: 213, a: 255, name: "papaya_whip"),
      "misty_rose" => Color.new(r: 255, g: 228, b: 225, a: 255, name: "misty_rose"),
      "lemon_chiffon" => Color.new(r: 255, g: 250, b: 205, a: 255, name: "lemon_chiffon"),
      "antique_white" => Color.new(r: 250, g: 235, b: 215, a: 255, name: "antique_white"),
      "cornsilk" => Color.new(r: 255, g: 248, b: 220, a: 255, name: "cornsilk"),
      "light_goldenrod_yellow" => Color.new(r: 250, g: 250, b: 210, a: 255, name: "light_goldenrod_yellow"),
      "old_lace" => Color.new(r: 253, g: 245, b: 230, a: 255, name: "old_lace"),
      "linen" => Color.new(r: 250, g: 240, b: 230, a: 255, name: "linen"),
      "light_yellow" => Color.new(r: 255, g: 255, b: 224, a: 255, name: "light_yellow"),
      "seashell" => Color.new(r: 255, g: 245, b: 238, a: 255, name: "seashell"),
      "beige" => Color.new(r: 245, g: 245, b: 220, a: 255, name: "beige"),
      "floral_white" => Color.new(r: 255, g: 250, b: 240, a: 255, name: "floral_white"),
      "ivory" => Color.new(r: 255, g: 255, b: 240, a: 255, name: "ivory"),
      "green" => Color.new(r: 0, g: 255, b: 0, a: 255, name: "green"),
      "lawn_green" => Color.new(r: 124, g: 252, b: 0, a: 255, name: "lawn_green"),
      "chartreuse" => Color.new(r: 127, g: 255, b: 0, a: 255, name: "chartreuse"),
      "green_yellow" => Color.new(r: 173, g: 255, b: 47, a: 255, name: "green_yellow"),
      "yellow_green" => Color.new(r: 154, g: 205, b: 50, a: 255, name: "yellow_green"),
      "medium_forest_green" => Color.new(r: 107, g: 142, b: 35, a: 255, name: "medium_forest_green"),
      "olive_drab" => Color.new(r: 107, g: 142, b: 35, a: 255, name: "olive_drab"),
      "dark_olive_green" => Color.new(r: 85, g: 107, b: 47, a: 255, name: "dark_olive_green"),
      "dark_sea_green" => Color.new(r: 143, g: 188, b: 139, a: 255, name: "dark_sea_green"),
      "lime" => Color.new(r: 0, g: 255, b: 0, a: 255, name: "lime"),
      "dark_green" => Color.new(r: 0, g: 100, b: 0, a: 255, name: "dark_green"),
      "lime_green" => Color.new(r: 50, g: 205, b: 50, a: 255, name: "lime_green"),
      "forest_green" => Color.new(r: 34, g: 139, b: 34, a: 255, name: "forest_green"),
      "spring_green" => Color.new(r: 0, g: 255, b: 127, a: 255, name: "spring_green"),
      "medium_spring_green" => Color.new(r: 0, g: 250, b: 154, a: 255, name: "medium_spring_green"),
      "sea_green" => Color.new(r: 46, g: 139, b: 87, a: 255, name: "sea_green"),
      "medium_sea_green" => Color.new(r: 60, g: 179, b: 113, a: 255, name: "medium_sea_green"),
      "aquamarine" => Color.new(r: 112, g: 216, b: 144, a: 255, name: "aquamarine"),
      "light_green" => Color.new(r: 144, g: 238, b: 144, a: 255, name: "light_green"),
      "pale_green" => Color.new(r: 152, g: 251, b: 152, a: 255, name: "pale_green"),
      "medium_aquamarine" => Color.new(r: 102, g: 205, b: 170, a: 255, name: "medium_aquamarine"),
      "turquoise" => Color.new(r: 64, g: 224, b: 208, a: 255, name: "turquoise"),
      "light_sea_green" => Color.new(r: 32, g: 178, b: 170, a: 255, name: "light_sea_green"),
      "medium_turquoise" => Color.new(r: 72, g: 209, b: 204, a: 255, name: "medium_turquoise"),
      "honeydew" => Color.new(r: 240, g: 255, b: 240, a: 255, name: "honeydew"),
      "mint_cream" => Color.new(r: 245, g: 255, b: 250, a: 255, name: "mint_cream"),
      "royal_blue" => Color.new(r: 65, g: 105, b: 225, a: 255, name: "royal_blue"),
      "dodger_blue" => Color.new(r: 30, g: 144, b: 255, a: 255, name: "dodger_blue"),
      "deep_sky_blue" => Color.new(r: 0, g: 191, b: 255, a: 255, name: "deep_sky_blue"),
      "cornflower_blue" => Color.new(r: 100, g: 149, b: 237, a: 255, name: "cornflower_blue"),
      "steel_blue" => Color.new(r: 70, g: 130, b: 180, a: 255, name: "steel_blue"),
      "light_sky_blue" => Color.new(r: 135, g: 206, b: 250, a: 255, name: "light_sky_blue"),
      "dark_turquoise" => Color.new(r: 0, g: 206, b: 209, a: 255, name: "dark_turquoise"),
      "cyan" => Color.new(r: 0, g: 255, b: 255, a: 255, name: "cyan"),
      "aqua" => Color.new(r: 0, g: 255, b: 255, a: 255, name: "aqua"),
      "dark_cyan" => Color.new(r: 0, g: 139, b: 139, a: 255, name: "dark_cyan"),
      "teal" => Color.new(r: 0, g: 128, b: 128, a: 255, name: "teal"),
      "sky_blue" => Color.new(r: 135, g: 206, b: 235, a: 255, name: "sky_blue"),
      "cadet_blue" => Color.new(r: 95, g: 158, b: 160, a: 255, name: "cadet_blue"),
      "dark_slate_gray" => Color.new(r: 47, g: 79, b: 79, a: 255, name: "dark_slate_gray"),
      "dark_slate_grey" => Color.new(r: 47, g: 79, b: 79, a: 255, name: "dark_slate_grey"),
      "light_slate_gray" => Color.new(r: 119, g: 136, b: 153, a: 255, name: "light_slate_gray"),
      "light_slate_grey" => Color.new(r: 119, g: 136, b: 153, a: 255, name: "light_slate_grey"),
      "slate_gray" => Color.new(r: 112, g: 128, b: 144, a: 255, name: "slate_gray"),
      "slate_grey" => Color.new(r: 112, g: 128, b: 144, a: 255, name: "slate_grey"),
      "light_steel_blue" => Color.new(r: 176, g: 196, b: 222, a: 255, name: "light_steel_blue"),
      "light_blue" => Color.new(r: 173, g: 216, b: 230, a: 255, name: "light_blue"),
      "powder_blue" => Color.new(r: 176, g: 224, b: 230, a: 255, name: "powder_blue"),
      "pale_turquoise" => Color.new(r: 175, g: 238, b: 238, a: 255, name: "pale_turquoise"),
      "light_cyan" => Color.new(r: 224, g: 255, b: 255, a: 255, name: "light_cyan"),
      "alice_blue" => Color.new(r: 240, g: 248, b: 255, a: 255, name: "alice_blue"),
      "azure" => Color.new(r: 240, g: 255, b: 255, a: 255, name: "azure"),
      "medium_blue" => Color.new(r: 0, g: 0, b: 205, a: 255, name: "medium_blue"),
      "dark_blue" => Color.new(r: 0, g: 0, b: 139, a: 255, name: "dark_blue"),
      "midnight_blue" => Color.new(r: 25, g: 25, b: 112, a: 255, name: "midnight_blue"),
      "navy" => Color.new(r: 36, g: 36, b: 140, a: 255, name: "navy"),
      "blue" => Color.new(r: 0, g: 0, b: 255, a: 255, name: "blue"),
      "indigo" => Color.new(r: 75, g: 0, b: 130, a: 255, name: "indigo"),
      "blue_violet" => Color.new(r: 138, g: 43, b: 226, a: 255, name: "blue_violet"),
      "medium_slate_blue" => Color.new(r: 123, g: 104, b: 238, a: 255, name: "medium_slate_blue"),
      "slate_blue" => Color.new(r: 106, g: 90, b: 205, a: 255, name: "slate_blue"),
      "purple" => Color.new(r: 160, g: 32, b: 240, a: 255, name: "purple"),
      "dark_slate_blue" => Color.new(r: 72, g: 61, b: 139, a: 255, name: "dark_slate_blue"),
      "dark_violet" => Color.new(r: 148, g: 0, b: 211, a: 255, name: "dark_violet"),
      "dark_orchid" => Color.new(r: 153, g: 50, b: 204, a: 255, name: "dark_orchid"),
      "medium_purple" => Color.new(r: 147, g: 112, b: 219, a: 255, name: "medium_purple"),
      "medium_orchid" => Color.new(r: 186, g: 85, b: 211, a: 255, name: "medium_orchid"),
      "magenta" => Color.new(r: 255, g: 0, b: 255, a: 255, name: "magenta"),
      "fuchsia" => Color.new(r: 255, g: 0, b: 255, a: 255, name: "fuchsia"),
      "dark_magenta" => Color.new(r: 139, g: 0, b: 139, a: 255, name: "dark_magenta"),
      "violet" => Color.new(r: 238, g: 130, b: 238, a: 255, name: "violet"),
      "plum" => Color.new(r: 221, g: 160, b: 221, a: 255, name: "plum"),
      "lavender" => Color.new(r: 230, g: 230, b: 250, a: 255, name: "lavender"),
      "thistle" => Color.new(r: 216, g: 191, b: 216, a: 255, name: "thistle"),
      "ghost_white" => Color.new(r: 248, g: 248, b: 255, a: 255, name: "ghost_white"),
      "white" => Color.new(r: 255, g: 255, b: 255, a: 255, name: "white"),
      "white_smoke" => Color.new(r: 245, g: 245, b: 245, a: 255, name: "white_smoke"),
      "gainsboro" => Color.new(r: 220, g: 220, b: 220, a: 255, name: "gainsboro"),
      "light_gray" => Color.new(r: 211, g: 211, b: 211, a: 255, name: "light_gray"),
      "light_grey" => Color.new(r: 211, g: 211, b: 211, a: 255, name: "light_grey"),
      "silver" => Color.new(r: 192, g: 192, b: 192, a: 255, name: "silver"),
      "gray" => Color.new(r: 190, g: 190, b: 190, a: 255, name: "gray"),
      "grey" => Color.new(r: 190, g: 190, b: 190, a: 255, name: "grey"),
      "dark_gray" => Color.new(r: 169, g: 169, b: 169, a: 255, name: "dark_gray"),
      "dark_grey" => Color.new(r: 169, g: 169, b: 169, a: 255, name: "dark_grey"),
      "dim_gray" => Color.new(r: 105, g: 105, b: 105, a: 255, name: "dim_gray"),
      "dim_grey" => Color.new(r: 105, g: 105, b: 105, a: 255, name: "dim_grey"),
      "black" => Color.new(r: 0, g: 0, b: 0, a: 255, name: "black"),
      "transparent" => Color.new(r: 0, g: 0, b: 0, a: 0, name: "transparent")
    })
end
