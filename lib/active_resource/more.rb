require 'active_support'
require 'active_record'
require 'active_record/base'
require 'active_record/validations'

require 'active_resource'
require 'active_resource/more/base'
require 'active_resource/more/configurations'
require 'active_resource/more/finders'
require 'active_resource/more/validations'
require 'active_resource/more/callbacks'

module ActiveResource
  module More
    def self.included(base) #:nodoc:
      base.class_eval do
        include Base
        include Configurations
        include Finders
        include Validations
        include Callbacks
      end
    end
  end
end
