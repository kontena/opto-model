require "opto/model/version"
require_relative 'model/initializer'
require_relative 'model/attribute_declaration'
require_relative 'model/association'
require_relative 'model/association/has_one/declaration'
require_relative 'model/association/has_many/declaration'

module Opto
  module Model
    def self.included(where)
      where.send :prepend, Initializer
      where.send :prepend, AttributeDeclaration
      where.send :prepend, Association
      where.send :prepend, Association::HasOne::Declaration
      where.send :prepend, Association::HasMany::Declaration
    end

    def inspect
      super.gsub(/\>\z/, " " + collection.members.map {|n, m| "#{m.handler.type}:#{n}: #{m.value.inspect}"}.join(', ') + ">")
    end

    def valid?(children = true)
      if children
        ([collection] + self.class.relations.map { |r| self.send(r) }).all?(&:valid?)
      else
        collection.valid?
      end
    end

    def errors(children = true)
      if children
        result = collection.errors
        self.class.relations.each do |relation|
          result.merge!(self.send(relation).errors)
        end
        result
      else
        collection.errors
      end
    end

    def to_h(children = true)
      if children
        result = to_h(false)
        self.class.relations.each do |r|
          result.merge!(self.send(r).to_h)
        end
        result
      else
        collection.to_h(values_only: true)
      end
    end
  end

  def self.model
    Model
  end
end
