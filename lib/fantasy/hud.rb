class Hud
  include Indexable
  include Node

  attr_reader :name
  attr_accessor :active

  def initialize(name: nil)
    @name = name
    @active = true
    Global.huds&.push(self)
  end

  def draw
    @children.each(&:draw)
  end

  def destroy
    log("#destroy")

    children.clone.each(&:destroy)
    children.clear

    Global.huds.delete(self)
  end

  def position_in_world
    (Camera.main.position + @position).freeze
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
