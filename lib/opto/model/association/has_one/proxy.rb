module Opto
  module Model
    module Association
      module HasOne
        class Proxy
          attr_reader :parent, :target, :target_class, :as, :options

          extend Forwardable

          def initialize(parent, target_class, as, target = nil, options = {})
            @parent, @target_class, @as, @target, @options = parent, target_class, as, target, options
          end

          def association_errors
            errors = { }
            if target.nil? && options[:required]
              errors[:presence] = "Missing child '#{as}'"
            end
            errors
          end

          def association_valid?
            association_errors.empty?
          end

          def method_missing(meth, *args)
            target.send(meth, *args)
          end

          def respond_to_missing?(meth, include_private = false)
            target.respond_to?(meth, include_private)
          end

          def new(*args)
            @target = target_class.new(*args)
          end

          def to_h
            target.nil? ? {} : { as => target.to_h }
          end

          def errors
            result = {}
            if target
              target_errors = target.errors
            else
              target_errors = {}
            end
            assoc_errors = association_errors

            if target_errors.empty? && assoc_errors.empty?
              {}
            else
              { as => target_errors.merge(assoc_errors) }
            end
          end

          def valid?
            association_valid? && (target && target.valid?)
          end

          def_delegators :target, :nil?, :class, :inspect, :kind_of?, :instance_of?, :is_a?
        end
      end
    end
  end
end

