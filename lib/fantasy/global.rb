require "ostruct"

module Global
  class << self
    attr_accessor :actors, :hud_texts, :hud_images, :backgrounds, :tile_maps, :clocks
    attr_accessor :debug
    attr_accessor :setup_proc, :loop_proc, :button_proc
    attr_accessor :presentation_proc, :game_proc, :end_proc

    attr_accessor :space_bar_proc
    attr_accessor :cursor_up_proc, :cursor_down_proc, :cursor_left_proc, :cursor_right_proc
    attr_accessor :mouse_button_left_proc, :mouse_button_right_proc

    attr_accessor :background

    attr_accessor :game
    attr_reader :frame_time # delta_time
    attr_reader :pixel_font
    attr_reader :references
    attr_reader :camera
    attr_reader :game_state

    def initialize
      puts "Global.initialize"
      @actors = []
      @hud_texts = []
      @hud_images = []
      @backgrounds = []
      @tile_maps = []
      @clocks = []
      @last_frame_at = Time.now
      @debug = false
      @pixel_font = Gosu::Font.new(20, { name: "#{__dir__}/../../fonts/VT323-Regular.ttf" } )
      @d_key_pressed = false
      @references = OpenStruct.new
      @camera = Camera.new(position: Coordinates.zero)
      @game_state = Global.presentation_proc.nil? ? "game" : "presentation"
      @game_started_at = Time.now

      if @presentation_proc.nil?
        on_presentation { Global.default_on_presentation  }
      end

      if @game_proc.nil?
        on_game { Global.default_on_game  }
      end

      if @end_proc.nil?
        on_end { Global.default_on_end  }
      end
    end

    def update
      @frame_time = Time.now - @last_frame_at
      @last_frame_at = Time.now

      if Gosu.button_down?(Gosu::KB_D) && !@d_key_pressed
        @debug = !@debug
        @d_key_pressed = true
      end

      if !Gosu.button_down?(Gosu::KB_D) && @d_key_pressed
        @d_key_pressed = false
      end
    end

    def add_reference(name:, object:)
      @references[name] = object
    end

    def default_on_presentation
      Global.go_to_game
    end

    def default_on_game
      raise "You have to define a 'on_game' block"
    end

    def default_on_end
      Global.go_to_presentation
    end

    def go_to_presentation
      puts "Game stage 'presentation'"

      clear_state_elements
      @presentation_proc.call
    end

    def go_to_game
      puts "Game stage 'game'"

      clear_state_elements
      game_proc.call
    end

    def go_to_end
      puts "Game stage 'end'"

      clear_state_elements
      end_proc.call
    end

    def clear_state_elements
      @actors.clear
      @hud_texts.clear
      @hud_images.clear
      @backgrounds.clear
      @tile_maps.clear
      @clocks.reject(&:persistent?).each(&:stop)
      @background = Color.new(r: 0, g: 0, b: 0)
    end

    def mouse_position
      Coordinates.new(Global.game.mouse_x, Global.game.mouse_y)
    end

    def setup
      Sound.preload_sounds
      Image.preload_images
    end

    def seconds_in_game
      Time.now - @game_started_at
    end
  end
end
