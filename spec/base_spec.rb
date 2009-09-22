require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class BaseTest < ActiveResource::Base
  include ActiveResource::More::Base
  self.site = 'http://localhost:3000'
  self.columns = [ :foo, :bar ]
end

describe ActiveResource::More::Base, '#initialize' do
  subject { BaseTest.new }

  it 'should make @attributes instance of HashWithIndifferentAccess' do
    subject.attributes.should be_an_instance_of(HashWithIndifferentAccess)
  end
  it 'should make @prefix_options instance of HashWithIndifferentAccess' do
    subject.prefix_options.should be_an_instance_of(HashWithIndifferentAccess)
  end
end

describe ActiveResource::More::Base, '#attributes=' do
  subject do
    BaseTest.new(:foo => 1).tap do |resource|
      resource.attributes = { :bar => 2 }
    end
  end

  it 'should set specified attribute' do
    subject.foo.should == 1
  end
  it 'should remain unspecified attribute' do
    subject.bar.should == 2
  end
end

describe ActiveResource::More::Base, '#method_missing' do
  shared_examples_for '#method_missing works with self.columns' do
    it 'should not raise error when fetch assigned attribute' do
      subject.foo.should == 1
    end
    it 'should be nil when fetch not assigned but column-contained attribute' do
      subject.bar.should be_nil
    end
    it 'should raise error when fetch not assigned and not column-contained attribute' do
      lambda { subject.baz }.should raise_error
    end
  end

  describe 'when symbol columns:' do
    subject { BaseTest.new(:foo => 1) }
    it_should_behave_like '#method_missing works with self.columns'
  end

  describe 'when string columns:' do
    before { BaseTest.columns = %w[ foo bar ] }
    subject { BaseTest.new(:foo => 1) }
    it_should_behave_like '#method_missing works with self.columns'
  end
end
