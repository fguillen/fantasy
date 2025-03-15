class Image < Gosu::Image
  attr_reader :name

  def initialize(file_path)
    super(file_path, { retro: true })
    @name = File.basename(file_path)
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

      raise "Sprite file not found with name '#{image_name}' in '#{base_path}' folder or any of its subfolders" if file_path.nil?

      @@images[image_name] = Image.new(file_path)

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
