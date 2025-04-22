class Hud
  include Indexable

  attr_accessor :position,
                :scale,
                :parts,
                :active,
                :layer

  def initialize
    @position = Coordinates.zero
    @scale = 1
    @parts = []
    @active = true
    @layer = 100

    Global.huds&.push(self)
  end

  def add_part(part)
    @parts.push(part)
  end

  def remove_part(part)
    @parts.delete(part)
  end

  def draw
    @parts.each(&:draw)
  end

  def destroy
    @parts.each(&:destroy)
  end

  def layer_in_world
    layer
  end

  class << self
    # @return [Hud] The active Hud
    attr_accessor :main

    # @!visibility private
    def initialize
      reset
    end

    # @!visibility private
    def reset
      @main&.destroy
      @main = Hud.new
    end
  end
end
