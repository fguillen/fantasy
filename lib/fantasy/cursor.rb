module Cursor
  def self.left
    Gosu::KB_LEFT
  end

  def self.right
    Gosu::KB_RIGHT
  end

  def self.up
    Gosu::KB_UP
  end

  def self.down
    Gosu::KB_DOWN
  end

  def self.space_bar
    Gosu::KB_SPACE
  end


  def self.left?
    Gosu.button_down?(Cursor.left)
  end

  def self.right?
    Gosu.button_down?(Cursor.right)
  end

  def self.up?
    Gosu.button_down?(Cursor.up)
  end

  def self.down?
    Gosu.button_down?(Cursor.down)
  end

  def self.space_bar?
    Gosu.button_down?(Cursor.space_bar)
  end
end
