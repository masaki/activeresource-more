module ActiveResource
  module More
    module Callbacks
      def self.included(base) #:nodoc:
        base.class_eval do
          include ActiveResource::More::Base
          include ActiveRecord::Callbacks # steal from AR
        end
      end
    end
  end
end
