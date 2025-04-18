module AutoFlipable
  def self.prepended(base)
    base.class_eval do
      attr_accessor :auto_flipable
    end
  end

  def do_after_move
    super
    return unless auto_flipable

    if @direction.x.positive?
      self.flip = "none"
    elsif @direction.x.negative?
      self.flip = "horizontal"
    end
  end
end
