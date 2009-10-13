class Test < ActiveResource::Base
  include ActiveResource::More
  self.site = 'http://localhost:3000'
end
