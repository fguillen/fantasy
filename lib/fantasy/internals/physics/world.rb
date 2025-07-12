module Physics
  class World
    class << self
      attr_accessor :id, :pixels_per_meter, :bodies

      def initialize(gravity: Coordinates.new(0, 0), pixels_per_meter: 100)
        world_def = Box2D::DefaultWorldDef()
        world_def.gravity.x = Global.physics_gravity.x
        world_def.gravity.y = Global.physics_gravity.y * -1 # Box2D uses Y down, so we invert it
        @id = Box2D::CreateWorld(world_def)
        @time_step = 1.0 # / 60.0
        @pixels_per_meter = pixels_per_meter

        @bodies = []

        # Box2D::World_EnableSleeping(@id, true)
        # Box2D::World_EnableWarmStarting(@id, true)
        # Box2D::World_EnableContinuous(@id, true)
      end

      def update
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
