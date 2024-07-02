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
    class << base
      alias_method :__new, :new
      def new(*args, **keyword_args)
        e = __new(*args, **keyword_args)
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

# module MyMixin
#   def self.included(base)
#     class << base
#       alias_method :_new, :new

#       define_method :new do
#         _new.tap do |instance|
#           instance.send(:after_init)
#         end
#       end
#     end
#   end

#   def after_init
#     puts 'hello'
#   end
# end
# module MyMod
#   def after_init
#     puts "MyMod#after_init"
#   end
#   def self.included(klass)
#     class << klass
#       alias_method :__new, :new
#       def new(*args)
#         e = __new(*args)
#         e.after_init
#         e
#       end
#     end
#   end
# end
