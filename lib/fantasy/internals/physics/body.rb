module Physics
  class Body
    include Log

    attr_reader :id, :type, :position, :rotation

    def initialize(position:, width:, height:, type: :dynamic)
      @position = position
      @width = width
      @height = height
      @type = type
      @id = create_body(position)
      @on_update_callback = nil
      @colliders = []
      @rotation = Box2D::ROT_IDENTITY

      created_default_collider

      Physics::World.add_body(self)
    end

    def destroy
      log("#destroy")
      Box2D::DestroyBody(id)
      Physics::World.remove_body(self)
    end

    def add_collider(position: Coordinates.zero, width: @width, height: @height, solid: true)
      collider =
        Physics::Collider.new(
          body_id: id,
          position: position,
          width: width,
          height: height,
          solid: solid
        )

      @colliders << collider

      remove_collider(@default_collider_id) if @default_collider_id

      collider
    end

    def remove_collider(collider)
      if @colliders.include?(collider)
        collider.destroy
        @colliders.delete(collider)
      end

      created_default_collider if @colliders.empty?
    end

    def update
      transform = Box2D::Body_GetTransform(id)
      physics_position = transform.p
      @position = Coordinates.new(physics_position.x, physics_position.y) / Physics::World.pixels_per_meter

      physics_rotation = transform.q
      angle_radians = Box2D.Rot_GetAngle(physics_rotation)
      @rotation = angle_radians * (180.0 / Math::PI) # degrees

      instance_exec(&@on_update_callback) unless @on_update_callback.nil?
    end

    def on_update(&block)
      @on_update_callback = block
    end

    def impulse(direction:, force:)
      impulse = Coordinates.new(direction.x, direction.y).normalize * force
      impulse_vec_2 = Box2D::Vec2.create_as(impulse.x, impulse.y)
      Box2D.Body_ApplyLinearImpulseToCenter(id, impulse_vec_2, true)
    end

    def force(direction:, force:)
      impulse = Coordinates.new(direction.x, direction.y).normalize * force * 1_000_000_000
      impulse_vec_2 = Box2D::Vec2.create_as(impulse.x, impulse.y)
      Box2D.Body_ApplyForceToCenter(id, impulse_vec_2, true)
    end

    def linear_velocity(velocity)
      velocity *= 1_000_000
      velocity_vec_2 = Box2D::Vec2.create_as(velocity.x, velocity.y)
      Box2D.Body_SetLinearVelocity(id, velocity_vec_2)
    end

    # def apply_forces(max_speed: Float::INFINITY)
    #   @acceleration ||= Coordinates.zero
    #   @velocity ||= Coordinates.zero

    #   @velocity += @acceleration

    #   @velocity.resize(max_speed) if @velocity.length > max_speed

    #   unless @velocity.length.zero?
    #     @position += @velocity * Global.frame_time
    #   end

    #   @acceleration = Coordinates.zero
    # end

    private

    def create_body(initial_position)
      body_def = Box2D::DefaultBodyDef()
      body_def.position.x = initial_position.x * Physics::World.pixels_per_meter
      body_def.position.y = initial_position.y * Physics::World.pixels_per_meter
      body_def.type = type == :static ? Box2D::BodyType_staticBody : Box2D::BodyType_dynamicBody
      body_def.fixedRotation = true

      Box2D::CreateBody(Physics::World.id, body_def)
    end

    def created_default_collider
      @default_collider_id = add_collider(solid: false)
    end
  end
end
