module Physics
  class Body
    include Log

    attr_reader :id, :type, :position

    def initialize(position:, width:, height:, type: :dynamic)
      @position = position
      @width = width
      @height = height
      @type = type
      @id = create_body(position)
      @on_update_callback = nil
      @colliders = []

      created_default_collider

      Physics::World.add_body(self)
    end

    def destroy
      log("#destroy")
      Box2D::DestroyBody(id)
      Physics::World.remove_body(self)
    end

    def add_collider(position: Coordinates.zero, width: @width, height: @height, solid: true)
      puts ">>> add_collider: #{position}, #{width}, #{height}, #{solid}"

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
      puts ">>>> remove_collider: #{collider.id}"

      if @colliders.include?(collider)
        collider.destroy
        @colliders.delete(collider)
      end

      created_default_collider if @colliders.empty?
    end

    def update
      pysics_position = Box2D::Body_GetTransform(id).p
      @position = Coordinates.new(pysics_position.x, pysics_position.y) / Physics::World.pixels_per_meter
      instance_exec(&@on_update_callback) unless @on_update_callback.nil?
    end

    def on_update(&block)
      @on_update_callback = block
    end

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
