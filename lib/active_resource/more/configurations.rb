ActiveResource::Base.class_eval do
  @@configurations = {}
  cattr_accessor :configurations

  class << self
    def register_configuration(name, config = nil)
      configurations[name.to_s] = config
    end
  end
end

module ActiveResource
  module More
    module Configurations
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def load_config(name = nil)
          name = model_name.underscore if name.blank?

          (configurations[name.to_s] || {}).each do |key, value|
            method = "#{key}="
            send(method, value) if respond_to?(method)
          end
        end
      end
    end
  end
end
