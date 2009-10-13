class User < ActiveResource::Base
  include ActiveResource::More

  site = 'http://localhost:3000'
  columns = %w[ name email password age display_name ]
end
