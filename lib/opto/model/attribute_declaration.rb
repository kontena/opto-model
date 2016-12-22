module Opto
  module Model
    module AttributeDeclaration

      def self.prepended(where)
        where.extend ClassMethods
      end

      module ClassMethods
        def attribute_definitions
          @attribute_definitions ||= []
        end

        def attribute(name, type, arguments = {})
          if attribute_definitions.find { |d| d[:name] == name }
            raise RuntimeError, "Duplicate attribute '#{name}'"
          end
          attribute_definitions << arguments.merge(name: name, type: type)

          define_method "#{name}_handler" do
            collection[name].handler
          end

          define_method name do
            collection[name].value
          end

          define_method "#{name}=" do |value|
            collection[name].set(value)
          end
        end
      end
    end
  end
end

