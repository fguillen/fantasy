# frozen_string_literal: true

module Sound
  class << self
    @@gosu_sounds = {}

    def play(sound_name, volume: 1)
      locate_sound(sound_name).play(volume)
    end

    def locate_sound(sound_name)
      return @@gosu_sounds[sound_name] if @@gosu_sounds[sound_name]

      puts "Initialize Sound: '#{sound_name}'"

      unless Dir.exist?(base_path.to_s)
        raise "The folder of sounds doesn't exists '#{base_path}', create the folder and put your sound '#{sound_name}' on it"
      end

      file_name = Dir.entries(base_path).find { |e| e =~ /^#{sound_name}($|\.)/ }

      raise "Sound file not found with name '#{sound_name}' in #{base_path}" if file_name.nil?

      @@gosu_sounds[sound_name] = Gosu::Sample.new("#{base_path}/#{file_name}")

      @@gosu_sounds[sound_name]
    end

    def preload_sounds
      return unless Dir.exist?(base_path)

      Dir.each_child(base_path) do |file_name|
        locate_sound(file_name) unless file_name.start_with?(".")
      end
    end

    def base_path
      "#{Dir.pwd}/sounds"
    end
  end
end
