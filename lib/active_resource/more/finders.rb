module ActiveResource
  module More
    module Finders
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def all(args = {})
          find(:all, args)
        end

        def first(args = {})
          find(:first, args)
        end

        def last(args = {})
          find(:last, args)
        end

        def count(args = {})
          all(args).length
        end
      end
    end
  end
end
