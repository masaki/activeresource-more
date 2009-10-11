require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveResource::More::Base, '#initialize' do
  subject { TestResource.new }

  it 'should make @attributes instance of HashWithIndifferentAccess' do
    subject.attributes.should be_an_instance_of(HashWithIndifferentAccess)
  end
  it 'should make @prefix_options instance of HashWithIndifferentAccess' do
    subject.prefix_options.should be_an_instance_of(HashWithIndifferentAccess)
  end
end

describe ActiveResource::More::Base, '#attributes=' do
  subject do
    resource = TestResource.new(:foo => 1)
    resource.attributes = { :bar => 2 }
    resource
  end

  it 'should set specified attribute' do
    subject.foo.should == 1
  end
  it 'should remain unspecified attribute' do
    subject.bar.should == 2
  end
end

describe ActiveResource::More::Base, '#attributes_or_columns' do
  subject { TestResource.new(:baz => 1) }

  it 'should be an instance of HashWithIndifferentAccess' do
    subject.attributes_or_columns.should be_an_instance_of(HashWithIndifferentAccess)
  end

  it 'should be a hash which merged with attributes and columns' do
    subject.attributes_or_columns.should have_key(:foo)
    subject.attributes_or_columns.should have_key(:bar)
    subject.attributes_or_columns.should have_key(:baz)

    subject.attributes_or_columns[:foo].should be_nil
    subject.attributes_or_columns[:bar].should be_nil
    subject.attributes_or_columns[:baz].should == 1
  end
end

describe ActiveResource::More::Base, '#respond_to?' do
  subject { TestResource.new(:baz => 1) }

  it 'should be true when key is in columns' do
    subject.class.column_names.each do |name|
      subject.should respond_to(name)
      subject.should respond_to("#{name}?")
      subject.should respond_to("#{name}=")
    end
  end
  it 'should be true when key is in attributes' do
    subject.attributes.keys.each do |name|
      subject.should respond_to(name)
      subject.should respond_to("#{name}?")
      subject.should respond_to("#{name}=")
    end
  end
  it 'should be false when key is not in attributes and columns' do
    subject.should_not respond_to(:quux)
  end
end

describe ActiveResource::More::Base, '#method_missing' do
  subject { TestResource.new(:baz => 'baz') }

  it 'should not raise NoMethodError when key is in columns' do
    subject.foo.should be_nil
    subject.bar.should be_nil
  end
  it 'should not raise NoMethodError when key is in attributes' do
    subject.baz.should == 'baz'
  end

  it 'should assign value to attributes when last key is a "="' do
    subject.baz = 'quux'
    subject.baz.should == 'quux'
  end
  it 'should check attributes when last key is a "?"' do
    subject.baz?.should_not be_nil
    subject.foo?.should be_nil
  end

  it 'should return a normal value when assign before_type_cast suffix' do
    subject.baz_before_type_cast.should == 'baz'
  end

  it 'should raise NoMethodError when key does not match any conditions' do
    lambda { subject.missing_method }.should raise_error(NoMethodError)
  end
end

describe ActiveResource::More::Base, '#create_or_update' do
  subject { TestResource.new }

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
        TestResource.new.tap do |resource|
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
      TestResource.new.tap do |resource|
        mock(resource).create_or_update { true }
      end
    end

    it 'should call #create_or_update and return true' do
      subject.save!.should be_true
    end
  end

  describe 'when #create_or_update returns false:' do
    subject do
      TestResource.new.tap do |resource|
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
        TestResource.new.tap do |resource|
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
      TestResource.new.tap do |resource|
        mock(resource).save! { true }
      end
    end

    it 'should call #save! and return true' do
      subject.update_attributes!({}).should be_true
    end
  end

  describe 'when #save! raise ActiveResource::ResourceNotSaved:' do
    subject do
      TestResource.new.tap do |resource|
        mock(resource).save! { raise ActiveResource::ResourceNotSaved }
      end
    end

    it 'should call #save and raise ActiveResource::ResourceNotSaved' do
      lambda { subject.update_attributes!({}) }.should raise_error(ActiveResource::ResourceNotSaved)
    end
  end
end
