# frozen_string_literal: true

# Keeps track of the creation order of the instance.
# Shared with other Indexable entities.
# Used in rendering time. If 2 entities are in the same layer. This value is
# used to render them in the same order.
#
# @example Automatically set of the creation index
#   actor = Actor.new("image")
#   actor.creation_index # => 1
#   message = HudText.new
#   message.creation_index # => 2
module Indexable
  class << self
    attr_accessor :last_creation_index
  end

  self.last_creation_index = 0

  # @return [Integer] the value of the creation index
  attr_reader :creation_index

  def self.included(base)
    # After create pattern
    class << base
      alias_method :_indexable_included_new, :new
      def new(*args, **keyword_args)
        e = _indexable_included_new(*args, **keyword_args)
        e.set_creation_index
        e
      end
    end

    define_method :set_creation_index do
      @creation_index = Indexable.last_creation_index + 1
      Indexable.last_creation_index = @creation_index
    end
  end
end
