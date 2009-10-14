module ActiveResource
  module More
    module Callbacks
      def self.included(base) #:nodoc:
        base.__send__ :include, ActiveRecord::Callbacks
      end
    end
  end
end
