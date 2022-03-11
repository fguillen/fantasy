module Sound
  class << self
    @@sounds = {}

    def play(sound_name)
      locate_sound(sound_name).play
    end

    def locate_sound(sound_name)
      return @@sounds[sound_name] if @@sounds[sound_name]

      puts "Initialize Sound: '#{sound_name}'"

      base_path = "#{__dir__}/../sounds"
      file_name = Dir.entries(base_path).find { |e| e.start_with?(sound_name) }
      @@sounds[sound_name] = Gosu::Sample.new("#{base_path}/#{file_name}")

      return @@sounds[sound_name]
    end
  end
end
