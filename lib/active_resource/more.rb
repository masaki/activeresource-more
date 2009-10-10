require 'active_support'
require 'active_resource'
require 'active_record'

require 'active_resource/more/base'
require 'active_resource/more/finders'
require 'active_resource/more/validations'
require 'active_resource/more/callbacks'

module ActiveResource
  module More
    def self.included(base) #:nodoc:
      base.class_eval do
        include Base
        include Finders
        include Validations
        include Callbacks
      end
    end
  end
end
