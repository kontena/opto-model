module Opto
  module Model
    module Association

      def self.prepended(where)
        where.extend ClassMethods
      end

      module ClassMethods
        def relations
          @relations ||= []
        end
      end
    end
  end
end
