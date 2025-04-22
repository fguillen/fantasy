module Node
  attr_reader :parent,
              :children,
              :position,
              :scale,
              :rotation,
              :layer

  def self.included(base)
    class << base
      alias_method :_node_included_new, :new
      def new(*args, **keyword_args)
        e = _node_included_new(*args, **keyword_args)
        e.init_node_basics
        e
      end
    end
  end

  def init_node_basics
    @children ||= []
    @parent ||= nil
    @scale ||= 1
    @position ||= Coordinates.new(0, 0)
    @rotation ||= 0
    @layer ||= 0
  end

  def parent=(node)
    if node.nil?
      remove_parent
      return
    end

    raise ArgumentError, "Node can not be parent of itself [#{node.class.name}, #{node.object_id}]" if node == self

    remove_parent

    raise ArgumentError, "Circular parent [#{node.class.name}, #{node.object_id}] -> [#{all_parents.map(&:object_id)}]" if all_parents.include?(node)

    @parent = node
    node.add_child(self)
  end

  def remove_parent
    @parent&.remove_child(self)
    @parent = nil
  end

  def add_child(node)
    @children.push(node) unless @children.include?(node)
    node.parent = self unless node.parent == self
  end

  def remove_child(node)
    return unless @children.include?(node)

    @children.delete(node)
    node.remove_parent
  end

  def all_parents
    if parent
      (parent.all_parents + [parent]).flatten.compact
    else
      []
    end
  end

  def actor
    all_parents.find { |parent| parent.is_a?(Actor) }
  end

  def active_in_world
    if parent
      active && parent.active
    else
      active
    end
  end

  def position_in_parent
    result = position.clone
    if parent
      if parent.flip == "horizontal" || parent.flip == "both"
        parent_width_center = parent.width / 2.to_f
        distant_to_center = parent_width_center - result.x
        result.x = parent_width_center + distant_to_center
        result.x -= width if respond_to?(:width)
      end
    end
    result
  end

  def position_in_world
    result = position_in_parent
    if parent
      result *= parent.scale
      result += parent.position_in_world
    end
    result.freeze
  end

  def position_in_world=(coordinates)
    if parent
      self.position = (coordinates - parent.position_in_world) / parent.scale
    else
      self.position = coordinates
    end
  end

  def width_in_world
    result = width
    result *= parent.scale if parent
    result *= scale if respond_to?(:scale)
    result
  end

  def height_in_world
    result = height
    result *= parent.scale if parent
    result *= scale if respond_to?(:scale)
    result
  end

  def scale_in_world
    if parent
      scale * parent.scale
    else
      scale
    end
  end

  def position_in_camera
    position_in_world - Camera.main.position
  end

  def rotation_in_world
    if parent
      rotation + parent.rotation
    else
      rotation
    end
  end

  def layer_in_world
    if parent
      layer + parent.layer
    else
      layer
    end
  end
end
