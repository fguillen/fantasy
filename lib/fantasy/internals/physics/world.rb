module Physics
  class World
    class << self
      attr_accessor :id, :pixels_per_meter, :bodies

      def initialize(gravity: Coordinates.zero, pixels_per_meter: 32)
        world_def = Box2D::DefaultWorldDef()
        world_def.gravity.x = gravity.x
        world_def.gravity.y = gravity.y
        @id = Box2D::CreateWorld(world_def)
        @time_step = 1.0 / 60.0
        @pixels_per_meter = pixels_per_meter

        @bodies = []
      end

      def update
        # puts "World.update"
        # Box2D::World_EnableSleeping(@id, true)
        # Box2D::World_EnableWarmStarting(@id, true)
        # Box2D::World_EnableContinuous(@id, true)
        Box2D::World_Step(@id, @time_step, 4)

        @bodies.each(&:update)
      end

      def add_body(body)
        @bodies << body
      end

      def remove_body(body)
        @bodies.delete(body)
      end
    end
  end
end
