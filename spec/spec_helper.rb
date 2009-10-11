$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_resource/more'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

# mock http requests
require 'active_resource/base'
require 'active_resource/http_mock'

ActiveResource::Base.class_eval do
  class << self
    def mock_request!(method, path, options = {})
      request_headers  = options[:request_headers]  || {}
      body             = options[:body]             || nil
      status           = options[:status]           || 200
      response_headers = options[:response_headers] || {}

      ActiveResource::HttpMock.respond_to do |mock|
        mock.send(method, path, request_headers, body, status, response_headers)
      end
    end

    def mock_get!(id, options = {})
      options = id if id.is_a?(Hash)
      path = options[:from] || element_path(id)
      mock_request! :get, path, options
    end
  end

  def mock_post!(options = {})
    self.class.mock_request! :post, self.class.collection_path, options
  end

  def mock_put!(options = {})
    self.class.mock_request! :put, self.class.element_path(id), options
  end

  def mock_delete!(options = {})
    self.class.mock_request! :delete, self.class.element_path(id), options
  end
end

# repair validate callbacks, from active_record/test/cases/repair_helper.rb
def record_validations(*klasses)
  klasses.inject({}) do |repair, klass|
    repair[klass] ||= {}
    [ :validate, :validate_on_create, :validate_on_update ].each do |phase|
      callbacks = klass.instance_variable_get("@#{phase.to_s}_callbacks")
      repair[klass][phase] = (callbacks.nil? ? nil : callbacks.dup)
    end
    repair
  end
end

def reset_validations(repairs)
  repairs.each do |klass, repair|
    [ :validate, :validate_on_create, :validate_on_update ].each do |phase|
      klass.instance_variable_set("@#{phase.to_s}_callbacks", repair[phase])
    end
  end
end

# test resource
class TestResource < ActiveResource::Base
  include ActiveResource::More

  self.site = 'http://localhost:3000'
  self.columns = [ :foo, 'bar' ]
end
