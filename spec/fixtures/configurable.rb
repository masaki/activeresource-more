class Configurable < ActiveResource::Base
  include ActiveResource::More
  self.site    = 'http://localhost:3000/foo'
  self.timeout = 60
end
