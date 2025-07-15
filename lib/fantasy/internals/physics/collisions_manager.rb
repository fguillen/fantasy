module Physics
  class CollisionsManager
    class << self
      def initialize
        @contacts = []
      end

      def update
        @contacts.clear
        @contacts.concat(collision_contacts)
        @contacts.concat(sensor_contacts)
        @contacts.compact!

        debugger unless @contacts.empty?

        # # Notify all actors about the contacts
        # @contacts.each do |contact|
        #   shape_a = Physics::World.find_shape_by_id(contact[:shape_id_a])
        #   shape_b = Physics::World.find_shape_by_id(contact[:shape_id_b])

        #   next unless shape_a && shape_b

        #   collider_a = shape_a.collider
        #   collider_b = shape_b.collider

        #   next unless collider_a && collider_b

        #   collider_a.on_collision_do(collider_b, contact)
        #   collider_b.on_collision_do(collider_a, contact)
        # end
      end

      def collision_contacts
        results = []

        events = Box2D::World_GetContactEvents(Physics::World.id)
        events.beginCount.times do |i|
          begin_touch_event = Box2D::ContactBeginTouchEvent.new(events.beginEvents + i * Box2D::ContactBeginTouchEvent.size)

          shape_id_a = begin_touch_event.shapeIdA
          shape_id_b = begin_touch_event.shapeIdB

          # We can get the final contact data from the shapes. The manifold is shared by the two shapes, so we just need the
          # contact data from one of the shapes. Choose the one with the smallest number of contacts.
          capacity_a = Box2D::Shape_GetContactCapacity(begin_touch_event.shapeIdA)
          capacity_b = Box2D::Shape_GetContactCapacity(begin_touch_event.shapeIdB)

          min_capacity = [capacity_a, capacity_b].min
          contact_data_buf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * min_capacity)

          count = Box2D::Shape_GetContactData(begin_touch_event.shapeIdA, contact_data_buf, min_capacity)
          count.times do |j|
            contact = Box2D::ContactData.new(contact_data_buf + j * Box2D::ContactData.size)

            manifold = contact.manifold
            first_point = manifold.points[0] # it may be more
            results << {
              point: first_point.point,
              normal: manifold.normal,
              shape_id_a: shape_id_a,
              shape_id_b: shape_id_b,
              type: :collision,
              event: :begin
            }
          end
        end

        results
      end

      def sensor_contacts
        results = []

        events = Box2D::World_GetSensorEvents(Physics::World.id)
        events.beginCount.times do |i|
          begin_touch_event = Box2D::ContactBeginTouchEvent.new(events.beginEvents + i * Box2D::ContactBeginTouchEvent.size)

          shape_id_a = begin_touch_event.shapeIdA
          shape_id_b = begin_touch_event.shapeIdB

          # We can get the final contact data from the shapes. The manifold is shared by the two shapes, so we just need the
          # contact data from one of the shapes. Choose the one with the smallest number of contacts.
          capacity_a = Box2D::Shape_GetContactCapacity(begin_touch_event.shapeIdA)
          capacity_b = Box2D::Shape_GetContactCapacity(begin_touch_event.shapeIdB)

          min_capacity = [capacity_a, capacity_b].min
          contact_data_buf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * min_capacity)

          count = Box2D::Shape_GetContactData(begin_touch_event.shapeIdA, contact_data_buf, min_capacity)
          count.times do |j|
            contact = Box2D::ContactData.new(contact_data_buf + j * Box2D::ContactData.size)

            manifold = contact.manifold
            first_point = manifold.points[0] # it may be more
            results << {
              point: first_point.point,
              normal: manifold.normal,
              shape_id_a: shape_id_a,
              shape_id_b: shape_id_b,
              type: :sensor,
              event: :begin
            }
          end
        end

        results
      end
    end
  end
end
