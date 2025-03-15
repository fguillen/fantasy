# frozen_string_literal: true

require "ostruct"

module Global
  class << self
    include Log

    attr_accessor :actors,
                  :graphics,
                  :hud_texts,
                  :hud_images,
                  :animations,
                  :backgrounds,
                  :tile_maps,
                  :clocks,
                  :shapes,
                  :tweens,
                  :colliders

    attr_accessor :debug
    attr_accessor :setup_proc, :loop_proc, :button_proc
    attr_accessor :presentation_proc, :game_proc, :end_proc

    attr_accessor :space_bar_proc
    attr_accessor :cursor_up_proc, :cursor_down_proc, :cursor_left_proc, :cursor_right_proc
    attr_accessor :mouse_button_left_proc, :mouse_button_right_proc

    attr_accessor :background

    attr_accessor :game
    attr_reader :frame_time # delta_time
    attr_reader :pixel_fonts
    attr_reader :references
    attr_reader :game_state

    attr_reader :screen_width, :screen_height

    # rubocop:disable Metrics/MethodLength
    def initialize(screen_width, screen_height)
      log "Global.initialize"
      @actors = []
      @graphics = []
      @hud_texts = []
      @hud_images = []
      @animations = []
      @backgrounds = []
      @tile_maps = []
      @clocks = []
      @shapes = []
      @tweens = []
      @colliders = []

      @last_frame_at = Time.now
      @debug = false

      @pixel_fonts = load_fonts

      @d_key_pressed = false
      @references = OpenStruct.new
      @game_state = Global.presentation_proc.nil? ? "game" : "presentation"
      @scene_started_at = Time.now
      @background = Color.new(r: 0, g: 0, b: 0)

      @frame_time = 0

      @screen_width = screen_width
      @screen_height = screen_height

      if @presentation_proc.nil?
        on_presentation { Global.default_on_presentation }
      end

      if @game_proc.nil?
        on_game { Global.default_on_game }
      end

      return unless @end_proc.nil?

      on_end { Global.default_on_end }
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Style/GuardClause
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
    # rubocop:enable Style/GuardClause

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
      log "Game stage 'presentation'"

      clear_state_elements
      @presentation_proc.call
    end

    def go_to_game
      log "Game stage 'game'"

      clear_state_elements
      game_proc.call
    end

    def go_to_end
      log "Game stage 'end'"

      clear_state_elements
      end_proc.call
    end

    def clear_state_elements
      @scene_started_at = Time.now

      clear_entities
      clear_callbacks
    end

    def mouse_position
      Coordinates.new(Global.game.mouse_x, Global.game.mouse_y)
    end

    def setup
      Sound.preload_sounds
      Image.preload_images
      Music.preload_musics
    end

    def seconds_in_scene
      Time.now - @scene_started_at
    end

    private

    def clear_entities
      @actors.clear
      @graphics.clear
      @hud_texts.clear
      @hud_images.clear
      @animations.clear
      @backgrounds.clear
      @tile_maps.clear
      @shapes.clear
      @tweens.clear
      @colliders.clear

      @clocks.reject(&:persistent?).each do |clock|
        clock.stop unless clock.thread == Thread.current # no stop current Thread
      end

      @background = Color.new(r: 0, g: 0, b: 0)

      Camera.reset
    end

    def clear_callbacks
      @button_proc = nil
      @space_bar_proc = nil
      @cursor_up_proc = nil
      @cursor_down_proc = nil
      @cursor_left_proc = nil
      @cursor_right_proc = nil
      @mouse_button_left_proc = nil
      @mouse_button_right_proc = nil
    end

    def load_fonts
      result = {}
      result["small"] = Gosu::Font.new(20, { name: "#{__dir__}/../../fonts/VT323-Regular.ttf" })
      result["medium"] = Gosu::Font.new(40, { name: "#{__dir__}/../../fonts/VT323-Regular.ttf" })
      result["big"] = Gosu::Font.new(60, { name: "#{__dir__}/../../fonts/VT323-Regular.ttf" })
      result["huge"] = Gosu::Font.new(100, { name: "#{__dir__}/../../fonts/VT323-Regular.ttf" })

      result
    end
  end
end
