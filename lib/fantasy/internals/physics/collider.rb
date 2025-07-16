module Physics
  class Collider
    include Log

    attr_reader :id, :body_id, :position, :width, :height, :solid

    def initialize(body_id:, position:, width:, height:, solid: true, group: "all", collision_with: "all")
      @position = position
      @body_id = body_id
      @solid = solid
      @width = width
      @height = height
      @group = group
      @collision_with = collision_with
      @id = create_collider
    end

    def destroy
      log("#destroy")
      Box2D::DestroyShape(@id, true)
    end

    def collision_with=(name_or_names)
      filter = Box2D.Shape_GetFilter(@id)
      filter.maskBits = Physics::Collider.bitmask_for(name_or_names)
      Box2D.Shape_SetFilter(@id, filter)
    end

    def self.bitmask_for(name_or_names)
      return 0xFFFF if name_or_names == "all"
      return 0x0000 if name_or_names == "none"

      if name_or_names.is_a?(Array)
        return combine_groups(name_or_names)
      end

      @bitmasks ||= {}
      @next_bit ||= 1

      @bitmasks[name_or_names] ||=
        begin
          bit = @next_bit
          @next_bit <<= 1
          bit
        end
    end

    def self.name_for(bitmask)
      @bitmasks.key(bitmask)
    end

    def self.combine_groups(names)
      names.map { |n| bitmask_for(n) }.inject(0, :|)
    end

    private

    def create_collider
      shape_def = Box2D::DefaultShapeDef()
      shape_def.enableContactEvents = true
      shape_def.enableSensorEvents = true
      shape_def.isSensor = !solid

      # Material properties
      shape_def.density = 1.0
      shape_def.material.friction = 0.3
      shape_def.material.restitution = 0.0

      # Collision groups
      filter = Box2D::Filter.new
      filter.categoryBits = Physics::Collider.bitmask_for(@group)
      filter.maskBits = Physics::Collider.bitmask_for(@collision_with)
      filter.groupIndex = 0
      shape_def.filter = filter

      # Dimensions and position
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
