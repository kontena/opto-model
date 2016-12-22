require_relative 'proxy'

module Opto
  module Model
    module Association
      module HasOne
        module Declaration
          def self.prepended(where)
            where.extend ClassMethods
          end

          module ClassMethods
            def has_one(relation, klass, options = {})
              if relations.include?(relation)
                raise RuntimeError, "Duplicate has_one relation '#{relation}'"
              end
              relations << relation

              define_method relation do
                if instance_variable_defined?("@#{relation}")
                  instance_variable_get("@#{relation}")
                else
                  instance_variable_set("@#{relation}", Proxy.new(self, klass, relation, nil, options))
                end
              end

              define_method "#{relation}=" do |arg|
                if arg.kind_of?(klass) || arg.nil?
                  instance_variable_set("@#{relation}", Proxy.new(self, klass, relation, arg, options))
                elsif arg.kind_of?(Hash)
                  self.send(relation).new(arg)
                else
                  raise TypeError, "Expected an instance of #{klass} or Hash or nil"
                end
              end
            end
          end
        end
      end
    end
  end
end

