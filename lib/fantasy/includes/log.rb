module Log
  def log(message)
    if ENV["debug"] == "active"
      full_message = "[#{Time.now.strftime("%T")}]"
      full_message += " [#{object_id}]"
      full_message += " [#{self.class.name}]"
      full_message += " [#{@name}]" if defined?(@name) && !@name.nil?
      full_message += " : #{message}"

      puts full_message
    end
  end

  def self.ignore_log(&block)
    original_debug = ENV["debug"]
    ENV["debug"] = "no-active"
    block.call
  ensure
    ENV["debug"] = original_debug
  end

  def self.debug_entities
    (
      Global.backgrounds +
      Global.tile_maps +
      Global.actors +
      Global.colliders +
      Global.hud_texts +
      Global.hud_images +
      Global.animations
    ).each do |entity|
      puts "Debug: #{entity.class} [#{entity.object_id}] [#{entity.name if entity.respond_to?(:name)}]"
      puts entity.to_debug if entity.respond_to?(:to_debug)
    end
  end
end
