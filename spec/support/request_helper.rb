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
