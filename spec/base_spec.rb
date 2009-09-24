require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class BaseTestResource < ActiveResource::Base
  include ActiveResource::More::Base
  self.site = 'http://localhost:3000'
  self.columns = [ :foo, :bar ]
end

describe ActiveResource::More::Base, '#initialize' do
  subject { BaseTestResource.new }

  it 'should make @attributes instance of HashWithIndifferentAccess' do
    subject.attributes.should be_an_instance_of(HashWithIndifferentAccess)
  end
  it 'should make @prefix_options instance of HashWithIndifferentAccess' do
    subject.prefix_options.should be_an_instance_of(HashWithIndifferentAccess)
  end
end

describe ActiveResource::More::Base, '#attributes=' do
  subject do
    BaseTestResource.new(:foo => 1).tap do |resource|
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
    subject { BaseTestResource.new(:foo => 1) }
    it_should_behave_like '#method_missing works with self.columns'
  end

  describe 'when string columns:' do
    before { BaseTestResource.columns = %w[ foo bar ] }
    subject { BaseTestResource.new(:foo => 1) }
    it_should_behave_like '#method_missing works with self.columns'
  end
end

describe ActiveResource::More::Base, '#create_or_update' do
  subject { BaseTestResource.new }

  it 'should call create when resource does not have id' do
    mock(subject).new_record? { true }
    mock(subject).create { true }
    subject.instance_eval { create_or_update }
  end

  it 'should call update when resource has id' do
    mock(subject).new_record? { false }
    mock(subject).update { true }
    subject.instance_eval { create_or_update }
  end
end

describe ActiveResource::More::Base, '#save' do
  [ true, false ].each do |result|
    describe "when #create_or_update returns #{result.to_s}:" do
      subject do
        BaseTestResource.new.tap do |resource|
          mock(resource).create_or_update { result }
        end
      end

      it "should call #create_or_update and return #{result.to_s}" do
        matcher = result ? be_true : be_false
        subject.save.should matcher
      end
    end
  end
end

describe ActiveResource::More::Base, '#save!' do
  describe 'when #create_or_update returns true:' do
    subject do
      BaseTestResource.new.tap do |resource|
        mock(resource).create_or_update { true }
      end
    end

    it 'should call #create_or_update and return true' do
      subject.save!.should be_true
    end
  end

  describe 'when #create_or_update returns false:' do
    subject do
      BaseTestResource.new.tap do |resource|
        mock(resource).create_or_update { false }
      end
    end

    it 'should call #create_or_update and raise ActiveResource::ResourceNotSaved' do
      lambda { subject.save! }.should raise_error(ActiveResource::ResourceNotSaved)
    end
  end
end

describe ActiveResource::More::Base, '#update_attributes' do
  [ true, false ].each do |result|
    describe "when #save returns #{result.to_s}:" do
      subject do
        BaseTestResource.new.tap do |resource|
          mock(resource).save { result }
        end
      end

      it "should call #save and return #{result.to_s}" do
        matcher = result ? be_true : be_false
        subject.update_attributes(:foo => 1).should matcher
      end
    end
  end
end

describe ActiveResource::More::Base, '#update_attributes!' do
  describe 'when #save! returns true:' do
    subject do
      BaseTestResource.new.tap do |resource|
        mock(resource).save! { true }
      end
    end

    it 'should call #save! and return true' do
      subject.update_attributes!({}).should be_true
    end
  end

  describe 'when #save! raise ActiveResource::ResourceNotSaved:' do
    subject do
      BaseTestResource.new.tap do |resource|
        mock(resource).save! { raise ActiveResource::ResourceNotSaved }
      end
    end

    it 'should call #save and raise ActiveResource::ResourceNotSaved' do
      lambda { subject.update_attributes!({}) }.should raise_error(ActiveResource::ResourceNotSaved)
    end
  end
end
