# frozen_string_literal: true

class Image
  def initialize(image_name)
    @image = Image.load(image_name)
  end

  def draw(x:, y:, scale: 1, rotation: 0, flip: "none")
    scale_x = scale
    scale_y = scale
    scale_x *= -1 if flip == "horizontal" || flip == "both"
    scale_y *= -1 if flip == "vertical" || flip == "both"

    # draw_rot(x, y, z = 0, angle = 0, center_x = 0.5, center_y = 0.5, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
    @image.draw_rot(x + (width / 2), y + (height / 2), 0, rotation, 0.5, 0.5, scale_x, scale_y)
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  class << self
    include Log

    @@images = {}

    def load(image_name)
      locate_image(image_name)
    end

    def preload_images
      return unless Dir.exist?(base_path)

      Dir.children(base_path).select { |e| e =~ /\.(png|jpg|jpeg)$/ }.each do |file_name|
        locate_image(file_name)
      end
    end

    private

    def locate_image(image_name)
      return @@images[image_name] if @@images[image_name]

      log "Initializing image: '#{image_name}' ..."

      unless Dir.exist?(base_path.to_s)
        raise "The folder of images doesn't exists '#{base_path}', create the folder and put your image '#{image_name}' on it"
      end

      file_name = Dir.children(base_path).find { |e| e =~ /^#{image_name}($|\.)/ }

      raise "Image file not found with name '#{image_name}' in #{base_path}" if file_name.nil?

      @@images[image_name] = Gosu::Image.new("#{base_path}/#{file_name}", { retro: true })

      log "Initialized image: '#{image_name}'"

      @@images[image_name]
    end

    def base_path
      if ENV["environment"] == "test"
        "#{Dir.pwd}/test/fixtures/images"
      else
        "#{Dir.pwd}/images"
      end
    end
  end
end
