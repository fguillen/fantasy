module Music
  class << self
    @@musics = {}
    @@actual_song = nil

    def play(music_name)
      stop

      @@actual_song = locate_music(music_name)
      @@actual_song.play(true)
    end

    def stop
      @@actual_song.stop unless @@actual_song.nil?
    end

    def volume
      @@actual_song&.volume
    end

    def volume=(value)
      @@actual_song.volume = value unless @@actual_song.nil?
    end

    def locate_music(music_name)
      return @@musics[music_name] if @@musics[music_name]

      puts "Initialize Music: '#{music_name}'"

      file_name = Dir.entries(base_path).find { |e| e =~ /^#{music_name}($|\.)/ }

      raise "Music file not found with name '#{music_name}'" if file_name.nil?

      @@musics[music_name] = Gosu::Song.new("#{base_path}/#{file_name}")

      return @@musics[music_name]
    end

    def preload_musics
      Dir.each_child(base_path) do |file_name|
        locate_music(file_name) unless file_name.start_with?(".")
      end
    end

    def base_path
      "#{Dir.pwd}/musics"
    end
  end
end
