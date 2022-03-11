class Color < Gosu::Color
  def initialize(r:, g:, b:, a: 255)
    super(a, r, g, b)
  end
end
