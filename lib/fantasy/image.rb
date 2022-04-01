# frozen_string_literal: true

class Image
  def initialize(image_name)
    @image = Image.load(image_name)
  end

  def draw(x:, y:, scale: 1)
    @image.draw(x, y, 0, scale, scale)
  end

  def width
    @image.width
  end

  def height
    @image.height
  end

  class << self
    @@images = {}

    def load(image_name)
      locate_image(image_name)
    end

    def preload_images
      return unless Dir.exist?(base_path)

      Dir.each_child(base_path) do |file_name|
        locate_image(file_name) unless file_name.start_with?(".")
      end
    end

    private

    def locate_image(image_name)
      return @@images[image_name] if @@images[image_name]

      puts "Initialize image: '#{image_name}'"

      file_name = Dir.entries(base_path).find { |e| e =~ /^#{image_name}($|\.)/ }

      raise "Image file not found with name '#{image_name}' in #{base_path}" if file_name.nil?

      @@images[image_name] = Gosu::Image.new("#{base_path}/#{file_name}", { retro: true })

      @@images[image_name]
    end

    def base_path
      "#{Dir.pwd}/images"
    end
  end
end
