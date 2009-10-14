module ActiveResource
  class ResourceNotSaved < StandardError
  end
end

module ActiveResource
  module More
    module Base
      def self.included(base) #:nodoc:
        base.__send__ :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def columns
          @columns ||= []
        end

        def columns=(new_columns = [])
          @columns = new_columns.map(&:to_s)
        end

        def column_names
          columns.map(&:to_s).sort
        end

        def columns_hash
          columns.inject({}.with_indifferent_access) { |hash, column| hash[column] = nil; hash }
        end
      end

      module InstanceMethods
        def initialize(attributes = {}) #:nodoc:
          super
          @attributes     = @attributes.with_indifferent_access
          @prefix_options = @prefix_options.with_indifferent_access
        end

        def attributes=(new_attributes = {})
          attributes.update(new_attributes)
        end

        def attributes_or_columns
          self.class.columns_hash.update(attributes)
        end

        def respond_to?(method, include_priv = false)
          method_name = method.to_s
          method_name.chop! if %[ ? = ].include?(method_name.last)

          attributes_or_columns.has_key?(method_name) ? true : super
        end

        def method_missing(method_symbol, *arguments) #:nodoc:
          method_name = method_symbol.to_s

          if method_name.last == "="
            attributes[method_name.first(-1)] = arguments.first
          elsif method_name.last == "?"
            attributes[method_name.first(-1)]
          elsif attributes.has_key?(method_name)
            attributes[method_name]
          elsif self.class.column_names.include?(method_name)
            attributes[method_name] = nil
          elsif method_name.match(/(\w+)_before_type_cast/)
            __send__($1)
          else
            super
          end
        end

        def save #:nodoc:
          create_or_update
        end

        def save! #:nodoc:
          create_or_update || raise(ResourceNotSaved)
        end

        def update_attributes(attributes)
          self.attributes = attributes
          save
        end

        def update_attributes!(attributes)
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
