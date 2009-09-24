require 'active_support'
require 'active_resource'
require 'active_record'

require 'active_resource/more/base'
require 'active_resource/more/callbacks'
require 'active_resource/more/validations'

module ActiveResource
  module More
    def self.included(base)
      base.class_eval do
        include Base
        include Callbacks
        include Validations
      end
    end
  end
end
