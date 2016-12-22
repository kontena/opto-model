module Opto
  module Model
    module Association
      module HasMany
        class Proxy
          attr_reader :parent, :members, :target_class, :as, :options

          extend Forwardable

          def initialize(parent, target_class, as, options = {})
            @parent, @target_class, @as, @options = parent, target_class, as, options
            @members = []
          end

          def association_errors
            errors = { }
            if members.empty? && options[:required]
              errors[:presence] = "Collection '#{as}' is empty"
            end
            errors
          end

          def association_valid?
            association_errors.empty?
          end

          def method_missing(meth, *args)
            members.send(meth, *args)
          end

          def respond_to_missing?(meth, include_private = false)
            members.respond_to?(meth, include_private)
          end

          def new(*args)
            target = target_class.new(*args)
            members << target
            target
          end

          def to_h
            empty? ? {} : { as => map(&:to_h) }
          end

          def errors
            result = { }
            each_with_index do |member, idx|
              errors = member.errors
              result[idx] = errors unless errors.empty?
            end
            result.merge!(association_errors || {})
            result.empty? ? {} : { as => result }
          end

          def_delegators :members, *::Array.instance_methods - [:__send__, :object_id, :to_h]
        end
      end
    end
  end
end



