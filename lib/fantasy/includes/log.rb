module Log
  def log(message)
    if ENV["debug"] == "active"
      full_message = "[#{Time.now.strftime("%T")}]"
      full_message += " [#{object_id}]"
      full_message += " [#{@name}]" if defined?(@name) && @name.present?
      full_message += " : #{message}"

      puts full_message
    end
  end
end
