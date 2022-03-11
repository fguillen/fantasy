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

    private

    def locate_image(image_name)
      return @@images[image_name] if @@images[image_name]

      puts "Initialize image: '#{image_name}'"

      base_path = "#{Dir.pwd}/images"
      file_name = Dir.entries(base_path).find { |e| e.start_with?("#{image_name}.") }

      raise "Image file not found with name '#{image_name}'" if file_name.nil?

      @@images[image_name] = Gosu::Image.new("#{base_path}/#{file_name}", { retro: true })

      return @@images[image_name]
    end
  end
end
