silence_stream($stderr) { load 'active_record/validations.rb' }

module ActiveResource
  class ResourceInvalid < ClientError
    # TODO: accept resource
  end

  module More
    class Error  < ::ActiveRecord::Error;  end
    class Errors < ::ActiveRecord::Errors; end

    module Validations
      def self.included(base) #:nodoc:
        base.class_eval do
          include ::ActiveRecord::Validations
          include InstanceMethods
        end
        base.extend ClassMethods
      end

      module ClassMethods
        def validates_uniqueness_of(*args)
          raise NoMethodError
        end
      end

      module InstanceMethods
        def save_with_validation(perform_validation = true)
          if perform_validation && valid? || !perform_validation
            save_without_validation
          else
            false
          end
        end

        def save_with_validation!
          if valid?
            save_without_validation!
          else
            raise ::ActiveResource::ResourceInvalid.new
          end
        end

        def valid?
          errors.clear

          run_callbacks(:validate)
          validate

          if new_record?
            run_callbacks(:validate_on_create)
            validate_on_create
          else
            run_callbacks(:validate_on_update)
            validate_on_update
          end

          super
        end

        def invalid?
          !valid?
        end

        def errors
          @errors ||= Errors.new(self)
        end

        protected
          def validate()           end
          def validate_on_create() end
          def validate_on_update() end
      end
    end
  end
end
