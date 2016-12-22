module Opto
  module Model
    class Attribute
      attr_reader :definition
      attr_reader :collection
      attr_reader :handler
      attr_reader :name

      def initialize(collection, definition, handler)
        @collection = collection
        @definition = definition
        @handler    = handler
        @name = definition[:name]
      end

      def set(value)
        handler.set(value)
      end

      def value
        handler.value
      end
    end
  end
end
