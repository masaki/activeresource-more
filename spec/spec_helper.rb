$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_resource/more'
require 'spec'
require 'spec/autorun'

# require "spec/support/**/*.rb"
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |file| require file }

Spec::Runner.configure do |config|
  config.mock_with :rr
  config.include Spec::Support::ActiveResource::RepairHelper
end
