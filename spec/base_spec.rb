require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/person')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/test')

describe ActiveResource::More::Base, '#initialize' do
  subject { User.new }

  it 'should make @attributes instance of HashWithIndifferentAccess' do
    subject.attributes.should be_an_instance_of(HashWithIndifferentAccess)
  end
  it 'should make @prefix_options instance of HashWithIndifferentAccess' do
    subject.prefix_options.should be_an_instance_of(HashWithIndifferentAccess)
  end
end

describe ActiveResource::More::Base, '#attributes=' do
  subject do
    User.new(:name => 'NAKAGAWA Masaki').tap { |user| user.password = 'password' }
  end

  it 'should set specified attribute' do
    subject.name.should == 'NAKAGAWA Masaki'
  end
  it 'should remain unspecified attribute' do
    subject.password.should == 'password'
  end
end

describe ActiveResource::More::Base, '#attributes_or_columns' do
  subject { User.new(:country => 'Japan') }

  it 'should be an instance of HashWithIndifferentAccess' do
    subject.attributes_or_columns.should be_an_instance_of(HashWithIndifferentAccess)
  end

  it 'should be a hash which merged with attributes and columns' do
    subject.attributes_or_columns.should have_key(:name)
    subject.attributes_or_columns[:name].should be_nil

    subject.attributes_or_columns.should have_key(:country)
    subject.attributes_or_columns[:country].should == 'Japan'
  end
end

describe ActiveResource::More::Base, '#respond_to?' do
  subject { User.new(:country => 'Japan') }

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
    subject.should_not respond_to(:is_not_defined_in_attributes_and_columns)
  end
end

describe ActiveResource::More::Base, '#method_missing' do
  subject { User.new(:country => 'Japan') }

  it 'should not raise NoMethodError when key is in columns' do
    subject.name.should be_nil
  end
  it 'should not raise NoMethodError when key is in attributes' do
    subject.country.should == 'Japan'
  end

  it 'should assign value to attributes when last key is a "="' do
    subject.address = 'Tokyo'
    subject.address.should == 'Tokyo'
  end

  it 'should check attributes when last key is a "?"' do
    subject.name?.should be_nil
    subject.country?.should_not be_nil
  end

  it 'should return a normal value when assign before_type_cast suffix' do
    subject.name_before_type_cast.should be_nil
    subject.country_before_type_cast.should == 'Japan'
  end

  it 'should raise NoMethodError when key does not match any conditions' do
    lambda { subject.is_not_defined_method_in_user }.should raise_error(NoMethodError)
  end
end

describe ActiveResource::More::Base, '#create_or_update' do
  subject { Test.new }

  it 'should call create when resource does not have id' do
    mock(subject).new_record? { true }
    mock(subject).create { true }
    dont_allow(subject).update
    subject.instance_eval { create_or_update }
  end

  it 'should call update when resource has id' do
    mock(subject).new_record? { false }
    mock(subject).update { true }
    dont_allow(subject).create
    subject.instance_eval { create_or_update }
  end
end

describe ActiveResource::More::Base, '#save' do
  [ true, false ].each do |result|
    describe "when #create_or_update returns #{result.to_s}:" do
      subject do
        Test.new.tap do |resource|
          mock(resource).create_or_update { result }
        end
      end

      it "should call #create_or_update and return #{result.to_s}" do
        subject.save.should result ? be_true : be_false
      end
    end
  end
end

describe ActiveResource::More::Base, '#save!' do
  describe 'when #create_or_update returns true:' do
    subject do
      Test.new.tap do |resource|
        mock(resource).create_or_update { true }
      end
    end

    it 'should call #create_or_update and return true' do
      subject.save!.should be_true
    end
  end

  describe 'when #create_or_update returns false:' do
    subject do
      Test.new.tap do |resource|
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
        Test.new.tap do |resource|
          mock(resource).save { result }
        end
      end

      it "should call #save and return #{result.to_s}" do
        subject.update_attributes(:foo => 1).should result ? be_true : be_false
      end
    end
  end
end

describe ActiveResource::More::Base, '#update_attributes!' do
  describe 'when #save! returns true:' do
    subject do
      Test.new.tap do |resource|
        mock(resource).save! { true }
      end
    end

    it 'should call #save! and return true' do
      subject.update_attributes!({}).should be_true
    end
  end

  describe 'when #save! raise ActiveResource::ResourceNotSaved:' do
    subject do
      Test.new.tap do |resource|
        mock(resource).save! { raise ActiveResource::ResourceNotSaved }
      end
    end

    it 'should call #save and raise ActiveResource::ResourceNotSaved' do
      lambda { subject.update_attributes!({}) }.should raise_error(ActiveResource::ResourceNotSaved)
    end
  end
end
