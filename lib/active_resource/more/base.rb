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
          @columns = new_columns.map(&:to_s)
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

        def column_names
          self.class.columns.map(&:to_s)
        end

        def method_missing(method_symbol, *arguments) #:nodoc:
          super
        rescue NoMethodError => e
          method_name = method_symbol.to_s
          if column_names.include?(method_name)
            send(method_name + '=', nil)
          elsif method_name.match(/(\w+)_before_type_cast/)
            send($1)
          else
            raise e # rethrow
          end
        end

        def save #:nodoc:
          create_or_update
        end

        def save! #:nodoc:
          create_or_update || raise(::ActiveResource::ResourceNotSaved)
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
