module Physics
  class CollisionsManager
    class << self
      def initialize
        @collisions = []
        @contacts = []
      end

      def update
        @contacts.clear
        @collisions.clear

        contactEvents = Box2D::World_GetContactEvents(Physics::World.id)
        contactEvents.beginCount.times do |i|
          beginTouchEvent = Box2D::ContactBeginTouchEvent.new(contactEvents.beginEvents + i * Box2D::ContactBeginTouchEvent.size)
          bodyIdA = Box2D::Shape_GetBody(beginTouchEvent.shapeIdA)
          bodyIdB = Box2D::Shape_GetBody(beginTouchEvent.shapeIdB)

          puts ">>>> Collision detected between body #{bodyIdA.index1} and body #{bodyIdB.index1}"

          shapeIdA = beginTouchEvent.shapeIdA
          shapeIdB = beginTouchEvent.shapeIdB

          puts ">>>> Shape ID A: #{shapeIdA.index1}"
          puts ">>>> Shape ID B: #{shapeIdB.index1}"

          fantasyColliderA = ::Collider.find_by_physics_shape_id(shapeIdA)
          fantasyColliderB = ::Collider.find_by_physics_shape_id(shapeIdB)

          puts ">>>> Fantasy Collider A: #{fantasyColliderA.name}"
          puts ">>>> Fantasy Collider B: #{fantasyColliderB.name}"

          # We can get the final contact data from the shapes. The manifold is shared by the two shapes, so we just need the
          # contact data from one of the shapes. Choose the one with the smallest number of contacts.
          capacityA = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdA)
          capacityB = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdB)

          puts ">>>> Contact capacity A: #{capacityA}"
          puts ">>>> Contact capacity B: #{capacityB}"

          #   if capacityA < capacityB
          #     contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityA)
          #     # pp [beginTouchEvent.shapeIdA, contactDataBuf, capacityA]
          #     countA = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdA, contactDataBuf, capacityA)
          #     countA.times do |j|
          #       contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          #       idA = contact.shapeIdA
          #       idB = contact.shapeIdB
          #       if Box2D::id_equals(idA, beginTouchEvent.shapeIdB) || Box2D::id_equals(idB, beginTouchEvent.shapeIdB)
          #         manifold = contact.manifold
          #         manifold.pointCount.times do |k|
          #           manifoldPoint = manifold.points[k]
          #           @contacts << manifoldPoint.point
          #         end
          #       end
          #     end
          #   else
          #     contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityB)
          #     # pp [beginTouchEvent.shapeIdB, contactDataBuf, capacityB]
          #     countB = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdB, contactDataBuf, capacityB)
          #     countB.times do |j|
          #       contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          #       idA = contact.shapeIdA
          #       idB = contact.shapeIdB
          #       if Box2D::id_equals(idA, beginTouchEvent.shapeIdA) || Box2D::id_equals(idB, beginTouchEvent.shapeIdA)
          #         manifold = contact.manifold
          #         manifold.pointCount.times do |k|
          #           manifoldPoint = manifold.points[k]
          #           @contacts << manifoldPoint.point
          #         end
          #       end
          #     end
          #   end
        end

        sensorEvents = Box2D::World_GetSensorEvents(Physics::World.id)
        sensorEvents.beginCount.times do |i|
          beginTouchEvent = Box2D::ContactBeginTouchEvent.new(sensorEvents.beginEvents + i * Box2D::ContactBeginTouchEvent.size)
          bodyIdA = Box2D::Shape_GetBody(beginTouchEvent.shapeIdA)
          bodyIdB = Box2D::Shape_GetBody(beginTouchEvent.shapeIdB)

          puts ">>>> Sensor detected between body #{bodyIdA.index1} and body #{bodyIdB.index1}"

          shapeIdA = beginTouchEvent.shapeIdA
          shapeIdB = beginTouchEvent.shapeIdB

          puts ">>>> Shape ID A: #{shapeIdA.index1}"
          puts ">>>> Shape ID B: #{shapeIdB.index1}"

          fantasyColliderA = ::Collider.find_by_physics_shape_id(shapeIdA)
          fantasyColliderB = ::Collider.find_by_physics_shape_id(shapeIdB)

          puts ">>>> Fantasy Collider A: #{fantasyColliderA.name}"
          puts ">>>> Fantasy Collider B: #{fantasyColliderB.name}"

          # We can get the final sensor data from the shapes. The manifold is shared by the two shapes, so we just need the
          # contact data from one of the shapes. Choose the one with the smallest number of contacts.
          capacityA = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdA)
          capacityB = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdB)

          puts ">>>> Contact capacity A: #{capacityA}"
          puts ">>>> Contact capacity B: #{capacityB}"

          #   if capacityA < capacityB
          #     contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityA)
          #     # pp [beginTouchEvent.shapeIdA, contactDataBuf, capacityA]
          #     countA = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdA, contactDataBuf, capacityA)
          #     countA.times do |j|
          #       contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          #       idA = contact.shapeIdA
          #       idB = contact.shapeIdB
          #       if Box2D::id_equals(idA, beginTouchEvent.shapeIdB) || Box2D::id_equals(idB, beginTouchEvent.shapeIdB)
          #         manifold = contact.manifold
          #         manifold.pointCount.times do |k|
          #           manifoldPoint = manifold.points[k]
          #           @contacts << manifoldPoint.point
          #         end
          #       end
          #     end
          #   else
          #     contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityB)
          #     # pp [beginTouchEvent.shapeIdB, contactDataBuf, capacityB]
          #     countB = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdB, contactDataBuf, capacityB)
          #     countB.times do |j|
          #       contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          #       idA = contact.shapeIdA
          #       idB = contact.shapeIdB
          #       if Box2D::id_equals(idA, beginTouchEvent.shapeIdA) || Box2D::id_equals(idB, beginTouchEvent.shapeIdA)
          #         manifold = contact.manifold
          #         manifold.pointCount.times do |k|
          #           manifoldPoint = manifold.points[k]
          #           @contacts << manifoldPoint.point
          #         end
          #       end
          #     end
          #   end
        end
      end
    end
  end
end
