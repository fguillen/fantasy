module Physics
  class Body
    attr_reader :id, :type, :position

    def initialize(position:, width:, height:, type: :dynamic)
      @position = position
      @type = type
      @id = create_body(position)
      @default_shape_id = created_default_shape(width, height)
      @on_update_callback = nil

      Physics::World.add_body(self)
    end

    def destroy
      Box2D::DestroyBody(Physics::World.id, id)
      Physics::World.remove_body(self)
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

    def created_default_shape(width, height)
      shape_def = Box2D::DefaultShapeDef()
      shape_def.enableContactEvents = true

      shape_def.density = 1.0
      shape_def.material.friction = 0.3
      shape_def.material.restitution = 0.0

      box_side_size_x = (width * Physics::World.pixels_per_meter).to_f / 2.0
      box_side_size_y = (height * Physics::World.pixels_per_meter).to_f / 2.0
      polygon = Box2D::MakeBox(box_side_size_x, box_side_size_y)
      Box2D::CreatePolygonShape(id, shape_def, polygon)
    end
  end
end
