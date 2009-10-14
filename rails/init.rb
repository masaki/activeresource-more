require_library_or_gem 'active_resource/more'

# config/resources.yml
resource_configuration_file = File.expand_path(RAILS_ROOT + '/config/resources.yml')
if File.exist?(resource_configuration_file)
  configurations = YAML.load(ERB.new(IO.read(resource_configuration_file)).result)
  configurations.each do |key, config|
    ActiveResource::Base.register_configuration(key, config[RAILS_ENV])
  end
end

# config/resourecs/*.yml
resource_configuration_dir = File.expand_path(RAILS_ROOT + '/config/resources')
Dir.glob(resource_configuration_dir + '/*.yml') do |file|
  key    = File.basename(file, '.rb')
  config = YAML.load(ERB.new(IO.read(file)).result)
  ActiveResource::Base.register_configuration(key, config[RAILS_ENV])
end
