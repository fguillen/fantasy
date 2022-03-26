module Sound
  class << self
    @@sounds = {}

    def play(sound_name)
      locate_sound(sound_name).play
    end

    def locate_sound(sound_name)
      return @@sounds[sound_name] if @@sounds[sound_name]

      puts "Initialize Sound: '#{sound_name}'"

      file_name = Dir.entries(base_path).find { |e| e =~ /^#{sound_name}($|\.)/ }

      raise "Sound file not found with name '#{sound_name}'" if file_name.nil?

      @@sounds[sound_name] = Gosu::Sample.new("#{base_path}/#{file_name}")

      return @@sounds[sound_name]
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
