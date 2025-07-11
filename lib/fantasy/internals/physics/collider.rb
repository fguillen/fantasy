module Physics
  class Collider
    include Log

    attr_reader :id, :body_id, :position, :width, :height, :solid

    def initialize(body_id:, position:, width:, height:, solid: true)
      @position = position
      @body_id = body_id
      @solid = solid
      @width = width
      @height = height
      @id = create_collider
    end

    def destroy
      log("#destroy")
      Box2D::DestroyShape(@id, true)
    end

    private

    def create_collider
      shape_def = Box2D::DefaultShapeDef()
      shape_def.enableContactEvents = true
      shape_def.isSensor = !solid

      shape_def.density = 1.0
      shape_def.material.friction = 0.3
      shape_def.material.restitution = 0.0

      box_side_size_x = (width * Physics::World.pixels_per_meter).to_f / 2.0
      box_side_size_y = (height * Physics::World.pixels_per_meter).to_f / 2.0
      position_x = position.x * Physics::World.pixels_per_meter
      position_y = position.y * Physics::World.pixels_per_meter
      center = Box2D::Vec2.create_as(position_x, position_y)
      rot_identity = Box2D::ROT_IDENTITY
      polygon = Box2D::MakeOffsetBox(box_side_size_x, box_side_size_y, center, rot_identity)
      Box2D::CreatePolygonShape(@body_id, shape_def, polygon)
    end
  end
end
