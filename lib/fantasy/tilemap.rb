# frozen_string_literal: true

class Tilemap
  include Indexable
  extend Log

  attr_accessor :position

  def initialize(map_name:, tiles:, tile_size: nil, tile_width: nil, tile_height: nil)
    @tile_width = tile_width || tile_size
    @tile_height = tile_height || tile_size

    if @tile_height.nil? || @tile_width.nil?
      raise("Tile size is not properly defined. Either you set a `tile_size` or a `tile_width` and `tile_height`")
    end

    @map_name = map_name
    @tiles = tiles
    @position = Coordinates.zero

    @grid = Tilemap.load_grid(@map_name)
  end

  def width
    @grid.max(&:length) * @tile_width
  end

  def height
    @grid.length * @tile_height
  end

  def spawn
    tile_position = Coordinates.zero

    @grid.each do |line|
      tile_position.x = 0

      line.each do |tile_index|
        unless tile_index.nil?
          render_tile(tile_index, tile_position)
        end

        tile_position.x += 1
      end

      tile_position.y += 1
    end
  end

  private

  def render_tile(tile_index, tile_position)
    actor_template = @tiles[tile_index]

    if actor_template.nil?
      raise "Tilemap config error. Not found Tile for index '#{tile_index}'"
    end

    actor = actor_template.clone
    actor.position.x = @position.x + (tile_position.x * @tile_width)
    actor.position.y = @position.y + (tile_position.y * @tile_height)
  end

  class << self
    @@maps = {}

    def load_grid(map_name)
      File.readlines(Tilemap.locate_map(map_name), chomp: true).map do |line|
        line.each_char.map do |char|
          char == " " ? nil : char.to_i
        end
      end
    end

    def locate_map(map_name)
      return @@maps[map_name] if @@maps[map_name]

      log "Initializing map: '#{map_name}' ..."

      unless Dir.exist?(base_path.to_s)
        raise "The folder of maps doesn't exists '#{base_path}', create the folder and put your map file '#{image_name}' on it"
      end

      file_name = Dir.entries(base_path).find { |e| e =~ /^#{map_name}($|\.)/ }

      raise "Map file not found with name '#{map_name}' in #{base_path}" if file_name.nil?

      @@maps[map_name] = "#{base_path}/#{file_name}"

      log "Initialized map: '#{map_name}' ..."

      @@maps[map_name]
    end

    def base_path
      if ENV["environment"] == "test"
        "#{Dir.pwd}/test/fixtures/maps"
      else
        "#{Dir.pwd}/maps"
      end
    end
  end
end
