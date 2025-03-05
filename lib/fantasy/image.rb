# frozen_string_literal: true

class Image
  attr_reader :image

  def initialize(image_name_or_gosu_image)
    @image = if image_name_or_gosu_image.is_a?(Gosu::Image)
               image_name_or_gosu_image
             else
               Image.load(image_name_or_gosu_image)
             end
  end

  def draw(x:, y:, scale: 1, rotation: 0, flip: "none")
    scale_x = scale
    scale_y = scale
    scale_x *= -1 if %w[horizontal both].include?(flip)
    scale_y *= -1 if %w[vertical both].include?(flip)

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

      all_images.each do |file_name|
        locate_image(File.basename(file_name))
      end
    end

    private

    def locate_image(image_name)
      return @@images[image_name] if @@images[image_name]

      log "Initializing image: '#{image_name}' ..."

      unless Dir.exist?(base_path.to_s)
        raise "The folder of images doesn't exists '#{base_path}', create the folder and put your image '#{image_name}' on it"
      end

      file_path = all_images.find { |e| File.basename(e) =~ /^#{image_name}($|\.)/ }

      raise "Image file not found with name '#{image_name}' in '#{base_path}' folder or any of its subfolders" if file_path.nil?

      @@images[image_name] = Gosu::Image.new(file_path, { retro: true })

      log "Initialized image: '#{image_name}'"

      @@images[image_name]
    end

    def all_images
      Dir.glob("#{base_path}/**/*").select { |e| File.basename(e) =~ /\.(png|jpg|jpeg)$/ }
    end

    def base_path
      if ENV["environment"] == "test"
        "#{Dir.pwd}/test/fixtures/assets"
      else
        "#{Dir.pwd}/assets"
      end
    end
  end
end
