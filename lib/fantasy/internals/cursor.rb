# frozen_string_literal: true

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

  def self.key_pressed?(button_id)
    Gosu.button_down?(button_id)
  end

  def self.left?
    Cursor.key_pressed?(Cursor.left)
  end

  def self.right?
    Cursor.key_pressed?(Cursor.right)
  end

  def self.up?
    Cursor.key_pressed?(Cursor.up)
  end

  def self.down?
    Cursor.key_pressed?(Cursor.down)
  end

  def self.space_bar?
    Cursor.key_pressed?(Cursor.space_bar)
  end
end
