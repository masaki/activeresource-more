require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/configurable')

describe ActiveResource::Base, '.register_configuration' do
  it 'should assign configuration hash' do
    key    = 'register_configuration_testing_key'
    config = { :timeout => 60 }

    ActiveResource::Base.configurations.should_not have_key(key)

    lambda {
      ActiveResource::Base.register_configuration(key, config)
    }.should change {
      ActiveResource::Base.configurations[key]
    }.from(nil).to(config)
  end
end

describe ActiveResource::More::Configurations, '.load_config' do
  before { Configurable.prefix = '/foo' }

  it 'should load configuration under specified key' do
    ActiveResource::Base.register_configuration(:prefix_with_bar, { :prefix => '/bar' })

    lambda {
      Configurable.load_config :prefix_with_bar
    }.should change(Configurable, :prefix).from('/foo').to('/bar')

    Configurable.timeout.should == 60
  end

  it 'should load configuration with default model name key when key is not specified' do
    ActiveResource::Base.register_configuration(:configurable, { :prefix => '/baz', :timeout => 10 })

    lambda {
      Configurable.load_config
    }.should change(Configurable, :prefix).from('/foo').to('/baz')

    Configurable.timeout.should == 10
  end
end
