# frozen_string_literal: true

# Represents a serie of images that correspond to an animation.
# An Animation can be assigned to an:
# * Actor.image
# * Button.image

class Animation

  # The actual image frame that is being rendered.
  #
  # Default `0`.
  #
  # @example Get the actual image frame
  #   animation = Animation.new(secuence: "image_secuence", columns: 3)
  #   animation.frame # => 0
  #
  # @example Set the initial frame in the constructor
  #   animation = Animation.new(secuence: "image_secuence", columns: 3, frame: 2)
  #   animation.frame # => 2
  attr_accessor :frame

  # The speed of the animation in frames per second.
  #
  # Default `10`.
  #
  # @example Get the animation speed
  #   animation = Animation.new(secuence: "image_secuence", columns: 3)
  #   animation.speed # => 10
  # @example Set the animation speed
  #   animation = Animation.new(secuence: "image_secuence", columns: 3)
  #   animation.speed = 20
  attr_accessor :speed

  # The name of the animation. By default is taken from the first image name.
  # Or from the secunce name
  #
  #
  # @example Get the name
  #   animation = Animation.new(secuence: "image_secuence", columns: 3)
  #   animation.name # => "image_secuence"
  # @example Set the name
  #   animation = Animation.new(secuence: "image_secuence", columns: 3)
  #   animation.name = "new_name"
  attr_accessor :name

  # Generates an Animation.
  #
  # There are two ways to instantiate an Animation:
  #
  # Using:
  # @param names [Array<String>] an array of image names from `./images/*`
  # You can specify a list of image names that correspond to the animation
  #
  # @example Instantiate an Animation from a list of image names.
  #   animation = Animation.new(names: ["image1", "image2", "image3"])
  #
  # Using:
  # @param secuence [string] the name of the image that contains the frames of the animation.
  # @param columns [integer] the number of images per column.
  # @param rows [integer] the number of images per row.
  # Only 'columns' or 'rows' is required. If not provided default is 1.
  #
  # @example Instantiate an Animation from an image with multiple frames
  #   animation = Animation.new(secuence: "image_secuence", columns: 3, rows: 1)
  #
  # Other params:
  # @param speed [integer] the number frames per second. Default `10`.
  # @param frame [integer] the initial frame. Default `0`.
  def initialize(names: nil, secuence: nil, columns: nil, rows: nil, speed: 10, frame: 0)
    if names.nil? && secuence.nil?
      raise ArgumentError, "'names' or 'secuence' must be provided"
    end

    if names && secuence
      raise ArgumentError, "only one of 'names' or 'secuence' must be provided"
    end

    if names && (columns || rows)
      raise ArgumentError, "'columns' and 'rows' are not needed if 'names' is provided"
    end

    if secuence && (columns.nil? && rows.nil?)
      raise ArgumentError, "'columns' and/or 'rows' must be provided if 'secuence' is provided"
    end

    if names
      @images = names.map { |image_name| Image.new(image_name) }
      @name = names.first
    end

    if secuence
      # we only require one, if the other is not present we use the default: 1
      columns ||= 1
      rows ||= 1
      @name = secuence
      @images = []

      secuence_image = Image.new(secuence)
      columns.times.each do |column|
        rows.times.each do |row|
          gosu_image = secuence_image.image
          frame_width = secuence_image.width / columns
          frame_height = secuence_image.height / rows
          gosu_subimage = gosu_image.subimage(column * frame_width, row * frame_height, frame_width, frame_height)
          @images << Image.new(gosu_subimage)
        end
      end
    end

    @frame = frame
    @speed = speed
    @last_frame_set_at = Global.seconds_in_scene

    Global.animations&.push(self)
  end

  def draw(x:, y:, scale: 1, rotation: 0, flip: "none")
    @images[@frame].draw(x: x, y: y, scale: scale, rotation: rotation, flip: flip)
  end

  def width
    @images[0].width
  end

  def height
    @images[0].height
  end

  def length
    @images.length
  end

  def update
    seconds_since_last_frame = Global.seconds_in_scene - @last_frame_set_at
    last_frame = @frame
    frames_offset = seconds_since_last_frame * @speed
    @frame += frames_offset.floor
    @frame %= length

    if last_frame != @frame
      @last_frame_set_at = Global.seconds_in_scene
    end
  end
end
