require 'active_resource/more/base'

module ActiveResource
  module More
    def self.included(base)
      base.class_eval do
        include Base
      end
    end
  end
end
