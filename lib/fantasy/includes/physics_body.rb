module PhysicsBody
  attr_reader :physics_body

  def self.prepended(base)
    # After create pattern
    class << base
      alias_method :_physics_body_included_new, :new
      def new(*args, **keyword_args)
        e = _physics_body_included_new(*args, **keyword_args)

        physics_body =
          Physics::Body.new(
            position: e.position,
            type: e.physics_type || :dynamic,
            width: e.width,
            height: e.height
          )
        physics_body.on_update { e.update_position_and_rotation }

        e.set_physics_body(physics_body)
        e
      end
    end

    define_method :set_physics_body do |physics_body|
      @physics_body = physics_body
    end
  end

  def destroy
    log("#PhysicsBody.destroy")
    super() if defined?(super)
    @physics_body&.destroy
  end

  def update_position_and_rotation
    if @physics_body
      @position = @physics_body.position
      @rotation = @physics_body.rotation
    end
  end
end
