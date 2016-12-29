require_relative 'proxy'

module Opto
  module Model
    module Association
      module HasMany
        module Declaration
          def self.prepended(where)
            where.extend ClassMethods
          end

          module ClassMethods
            def has_many(relation, klass, options = {})
              if relations.include?(relation)
                raise RuntimeError, "Duplicate has_many relation '#{relation}'"
              end
              relations << relation

              define_method relation do
                if instance_variable_defined?("@#{relation}")
                  instance_variable_get("@#{relation}")
                else
                  instance_variable_set("@#{relation}", Proxy.new(self, klass, relation, options))
                end
              end

              define_method "#{relation}=" do |args|
                if args.kind_of?(Array)
                  self.send(relation).clear
                  args.each do |arg|
                    if arg.kind_of?(klass)
                      self.send(relation).push(arg)
                    elsif arg.kind_of?(Hash)
                      self.send(relation).new(arg)
                    else
                      raise TypeError, "Expected an instance of #{klass} or Hash"
                    end
                  end
                  self.send(relation).members
                elsif args.kind_of?(Hash)
                  self.send(relation).clear
                  args.each do |k,v|
                    if v.kind_of?(Hash)
                      self.send(relation).new(k => v)
                    else
                      raise TypeError, "Expected an instance of Hash"
                    end
                  end
                  self.send(relation).members
                elsif args.nil?
                  self.send(relation).clear
                else
                  raise TypeError, "Expected an instance of Array"
                end
              end
            end
          end
        end
      end
    end
  end
end


