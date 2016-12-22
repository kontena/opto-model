require_relative 'attribute_collection'

module Opto
  module Model
    module Initializer

      def initialize(attributes = {})
        initialize_collection
        assign(attributes)
      end

      def initialize_collection
        @collection = AttributeCollection.new(self.class.attribute_definitions)
      end

      def collection
        @collection
      end

      def assign(attributes)
        attributes.each do |key, value|
          if self.respond_to?("#{key}=")
            self.send("#{key}=", value)
          else
            raise ArgumentError, "Unknown attribute '#{key}'"
          end
        end
      end

    end
  end
end
