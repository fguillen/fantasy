# frozen_string_literal: true

module UserInputs
  # Set callbacks
  def on_cursor_down(&block)
    @on_cursor_down_callback = block
  end

  def on_cursor_up(&block)
    @on_cursor_up_callback = block
  end

  def on_cursor_left(&block)
    @on_cursor_left_callback = block
  end

  def on_cursor_right(&block)
    @on_cursor_right_callback = block
  end

  def on_space_bar(&block)
    @on_space_bar_callback = block
  end

  def on_mouse_button_left(&block)
    @on_mouse_button_left_callback = block
  end

  def on_click(&block)
    @on_click_callback = block
  end

  # Execute callbacks
  def on_cursor_down_do
    instance_exec(&@on_cursor_down_callback) unless @on_cursor_down_callback.nil?
  end

  def on_cursor_up_do
    instance_exec(&@on_cursor_up_callback) unless @on_cursor_up_callback.nil?
  end

  def on_cursor_left_do
    instance_exec(&@on_cursor_left_callback) unless @on_cursor_left_callback.nil?
  end

  def on_cursor_right_do
    instance_exec(&@on_cursor_right_callback) unless @on_cursor_right_callback.nil?
  end

  def on_space_bar_do
    instance_exec(&@on_space_bar_callback) unless @on_space_bar_callback.nil?
  end

  def on_mouse_button_left_do
    instance_exec(&@on_mouse_button_left_callback) unless @on_mouse_button_left_callback.nil?
  end

  def on_click_do
    puts "XXX: on_click_do: #{@on_click_callback}"
    instance_exec(&@on_click_callback) unless @on_click_callback.nil?
  end

  protected

  attr_accessor :on_cursor_down_callback, :on_cursor_up_callback, :on_cursor_left_callback, :on_cursor_right_callback, :on_space_bar_callback, :on_mouse_button_left_callback
end
