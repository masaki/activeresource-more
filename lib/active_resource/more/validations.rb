module ActiveResource
  # Raised by <tt>save!</tt> (and <tt>update_attributes!</tt>) when the resource is invalid.
  # Please look at ActiveRecord::RecordInvalid for more information.
  class ClientResourceInvalid < ActiveRecord::RecordInvalid
  end

  module More
    class Error < ActiveRecord::Error #:nodoc:
    end

    class Errors < ActiveRecord::Errors #:nodoc:
    end

    # Module to support client side validation and errors with Active Resource objects.
    # Please look at ActiveRecord::Validations for more information.
    module Validations
      def self.included(base) #:nodoc:
        base.__send__ :include, ActiveRecord::Validations, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods #:nodoc:
        def validates_uniqueness_of(*args) #:nodoc:
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
            raise ClientResourceInvalid.new(self)
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
