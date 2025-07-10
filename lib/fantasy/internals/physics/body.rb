module Physics
  class Body
    attr_reader :id, :type, :position

    def initialize(position:, type: :dynamic)
      @position = position
      @type = type
      @id = create_body
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
      puts ">>>> Physics::Body.update: id: #{id}, position: #{@position.inspect}"
      instance_exec(&@on_update_callback) unless @on_update_callback.nil?
    end

    def on_update(&block)
      @on_update_callback = block
    end

    private

    def create_body
      body_def = Box2D::DefaultBodyDef()
      body_def.position.x = position.x
      body_def.position.y = position.y
      body_def.type = type == :static ? Box2D::BodyType_staticBody : Box2D::BodyType_dynamicBody
      body_def.fixedRotation = true

      puts ">>>> Physics::World.id: #{Physics::World.id}, body_def: #{body_def.inspect}"
      Box2D::CreateBody(Physics::World.id, body_def)
    end
  end
end
