require 'active_support/core_ext/hash/indifferent_access'
require 'active_resource'

module ActiveResource
  class ResourceNotSaved < StandardError
  end
end

module ActiveResource
  module More
    module Base
      def self.included(base) #:nodoc:
        base.extend ClassMethods
        base.class_eval do
          include InstanceMethods
        end
      end

      module ClassMethods #:nodoc:
        def columns #:nodoc:
          @columns ||= []
        end

        def columns=(new_columns = []) #:nodoc:
          @columns = new_columns.map(&:to_sym)
        end
      end

      module InstanceMethods #:nodoc:
        def initialize(attributes = {}) #:nodoc:
          super
          @attributes     = @attributes.with_indifferent_access
          @prefix_options = @prefix_options.with_indifferent_access
        end

        def attributes=(new_attributes = {}) #:nodoc:
          attributes.update(new_attributes)
        end

        def method_missing(method_symbol, *arguments) #:nodoc:
          super
        rescue NoMethodError => e
          if self.class.columns.include?(method_symbol)
            send(method_symbol.to_s + '=', nil)
          else
            raise e # rethrow
          end
        end

        def save #:nodoc:
          create_or_update
        end

        def save! #:nodoc:
          create_or_update || raise(ActiveResource::ResourceNotSaved)
        end

        def update_attributes(attributes) #:nodoc:
          self.attributes = attributes
          save
        end

        def update_attributes!(attributes) #:nodoc:
          self.attributes = attributes
          save!
        end

      private
        def create_or_update #:nodoc:
          new_record? ? create : update
        end
      end
    end
  end
end
