module PhysicsBody
  attr_reader :physics_body

  def self.included(base)
    # After create pattern
    class << base
      alias_method :_physics_body_included_new, :new
      def new(*args, **keyword_args)
        e = _physics_body_included_new(*args, **keyword_args)
        physics_body = Physics::Body.new(position: e.position, type: :dynamic)
        physics_body.on_update { e.force_position }
        e.set_physics_body(physics_body)
        e
      end
    end

    define_method :set_physics_body do |physics_body|
      @physics_body = physics_body
    end
  end

  def destroy
    @physics_body&.destroy
    super() if defined?(super)
  end

  def force_position
    puts ">>>> PhysicsBody.force_position: id: #{@physics_body.id}, position: #{@physics_body.position.inspect}" if @physics_body
    @position = @physics_body.position if @physics_body
  end
end
