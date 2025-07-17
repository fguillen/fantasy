module Physics
  class CollisionsManager
    class << self
      include Log

      def initialize
        @contacts = []
      end

      def update
        @contacts = collect_contacts
        log "Contacts: #{@contacts.inspect}" unless @contacts.empty?

        propagate_contacts(@contacts) unless @contacts.empty?
      end

      def propagate_contacts(contacts)
        contacts.each do |contact|
          collider_a = ::Collider.find_by_physics_shape_id_index(contact[:shape_id_a_index])
          collider_b = ::Collider.find_by_physics_shape_id_index(contact[:shape_id_b_index])

          puts ">>> collider_a: #{collider_a}, collider_b: #{collider_b}"
          puts ">>>> contact: #{contact.inspect}"

          if contact[:phase] == :begin
            collider_a.on_collision_do(collider_b, contact_for_a(contact))
            collider_b.on_collision_do(collider_a, contact_for_b(contact))
          end

          if contact[:phase] == :end
            collider_a.on_collision_ends_do(collider_b, contact_for_a(contact))
            collider_b.on_collision_ends_do(collider_a, contact_for_b(contact))
          end
        end
      end

      private

      def contact_for_a(contact)
        result = contact.dup
        result[:anchor] = result[:anchor_a]
        result.delete(:anchor_a)
        result.delete(:anchor_b)
        result
      end

      def contact_for_b(contact)
        result = contact.dup
        result[:anchor] = result[:anchor_b]
        result.delete(:anchor_a)
        result.delete(:anchor_b)
        result
      end

      def collect_contacts
        results = []
        results.concat(collision_contacts)
        results.concat(sensor_contacts)
        results.compact!
        results
      end

      def collision_contacts
        results = []

        events = Box2D::World_GetContactEvents(Physics::World.id)

        events.beginCount.times do |i|
          begin_touch_event = Box2D::ContactBeginTouchEvent.new(events.beginEvents + i * Box2D::ContactBeginTouchEvent.size)
          results.concat(digest_begin_touch_event(begin_touch_event, type: :collision))
        end

        events.endCount.times do |i|
          end_touch_event = Box2D::ContactEndTouchEvent.new(events.endEvents + i * Box2D::ContactEndTouchEvent.size)
          results.push(digest_simple_touch_event(end_touch_event, type: :collision, phase: :end))
        end

        results
      end

      def sensor_contacts
        results = []

        events = Box2D::World_GetSensorEvents(Physics::World.id)

        events.beginCount.times do |i|
          begin_touch_event = Box2D::ContactBeginTouchEvent.new(events.beginEvents + i * Box2D::ContactBeginTouchEvent.size)
          results.push(digest_simple_touch_event(begin_touch_event, type: :sensor, phase: :begin))
        end

        events.endCount.times do |i|
          end_touch_event = Box2D::ContactEndTouchEvent.new(events.endEvents + i * Box2D::ContactEndTouchEvent.size)
          results.push(digest_simple_touch_event(end_touch_event, type: :sensor, phase: :end))
        end

        results
      end


      def digest_begin_touch_event(event, type:)
        results = []

        # We can get the final contact data from the shapes. The manifold is shared by the two shapes, so we just need the
        # contact data from one of the shapes. Choose the one with the smallest number of contacts.
        capacity_a = Box2D::Shape_GetContactCapacity(event.shapeIdA)
        capacity_b = Box2D::Shape_GetContactCapacity(event.shapeIdB)

        min_capacity = [capacity_a, capacity_b].min
        contact_data_buf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * min_capacity)

        count = Box2D::Shape_GetContactData(event.shapeIdA, contact_data_buf, min_capacity)
        count.times do |j|
          contact = Box2D::ContactData.new(contact_data_buf + j * Box2D::ContactData.size)

          manifold = contact.manifold
          first_point = manifold.points[0] # it may be more
          results << {
            shape_id_a_index: event.shapeIdA.index1,
            shape_id_b_index: event.shapeIdB.index1,
            type:,
            phase: :begin,
            coordinates: Coordinates.new(first_point.point.x, first_point.point.y) / Physics::World.pixels_per_meter,
            normal: Coordinates.new(manifold.normal.x, manifold.normal.y * -1), # Y is inverted in Box2D
            anchor_a: Coordinates.new(first_point.anchorA.x, first_point.anchorA.y), # Y is inverted in Box2D
            anchor_b: Coordinates.new(first_point.anchorB.x, first_point.anchorB.y) # Y is inverted in Box2D
          }
        end

        results
      end

      def digest_simple_touch_event(event, type:, phase:)
        {
          shape_id_a_index: event.shapeIdA.index1,
          shape_id_b_index: event.shapeIdB.index1,
          type:,
          phase:,
          coordinates: nil,
          normal: nil,
          anchor_a: nil,
          anchor_b: nil
        }
      end
    end
  end
end
