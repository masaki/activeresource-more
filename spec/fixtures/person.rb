class User < ActiveResource::Base
  include ActiveResource::More

  self.site = 'http://localhost:3000'
  self.columns = %w[ name email password age display_name ]
end
