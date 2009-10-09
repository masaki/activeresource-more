module ActiveResource
  module More
    module Callbacks
      def self.included(base) #:nodoc:
        base.class_eval do
          include ::ActiveRecord::Callbacks
        end
      end
    end
  end
end
