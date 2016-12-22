require 'opto'
require_relative 'attribute'

module Opto
  module Model
    class AttributeCollection

      extend Forwardable

      attr_reader :members
      attr_reader :group

      def initialize(attribute_definitions = [])
        @members = {}
        @group = Opto::Group.new

        build_members(attribute_definitions)
      end

      def inspect
        string = "#<#{self.class.name}:#{self.object_id} "
        string << "members: #{members.keys.inspect}"
        string << ">"
        string
      end

      def [](name)
        members[name]
      end

      def build_member(definition)
        members[definition[:name]] = Attribute.new(self, definition, group.build_option(definition))
      end

      def build_members(definitions)
        definitions.each { |definition| build_member(definition) }
      end

      def errors
        Hash[*group.errors.flat_map { |k,v| [k.to_sym, v] }]
      end

      def_delegators :group, :valid?, :all_true?, :any_true?, :to_h
    end
  end
end
