require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class ValidationsTestResource < ActiveResource::Base
  include ActiveResource::More::Validations
  self.site = 'http://localhost:3000'
  self.columns = [ :foo, :bar ]
end

describe ActiveResource::More::Validations, '.validates_acceptance_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.validates_acceptance_of(:foo, :baz)
    ValidationsTestResource.new
  end

  it 'should define unregistered column attribute accessor' do
    subject.should be_respond_to(:baz)
    subject.baz.should be_nil
  end

  it 'should be valid when attribute is undefined' do
    subject.should be_valid
  end

  it 'should be valid when attribute is present' do
    subject.foo = '1'
    subject.should be_valid
  end

  it 'should not be valid when attribute is blank' do
    subject.foo = ''
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_confirmation_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.validates_confirmation_of(:foo)
    ValidationsTestResource.new
  end

  it 'should define confirm accessor' do
    subject.should be_respond_to(:foo_confirmation)
    subject.foo_confirmation.should be_nil
  end

  it 'should be valid when each attributes are blank' do
    subject.foo              = ''
    subject.foo_confirmation = ''
    subject.should be_valid
  end

  it 'should be valid when each attributes are equivalent' do
    subject.foo              = '1'
    subject.foo_confirmation = '1'
    subject.should be_valid
  end

  it 'should be valid when confirmation attribute is undefined' do
    subject.foo = '1'
    subject.should be_valid
  end

  it 'should not be valid when each attributes are different' do
    subject.foo              = '1'
    subject.foo_confirmation = '2'
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_exclusion_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.validates_exclusion_of(:foo, :in => %w[ bar baz ])
    ValidationsTestResource.new
  end

  it 'should be valid when attribute is not in exclusion list' do
    subject.foo = 'quux'
    subject.should be_valid
  end

  it 'should not be valid when attribute is in exclusion list' do
    subject.foo = 'bar'
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_inclusion_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.validates_inclusion_of(:foo, :in => %w[ bar baz ])
    ValidationsTestResource.new
  end

  it 'should be valid when attribute is in inclusion list' do
    subject.foo = 'bar'
    subject.should be_valid
  end

  it 'should not be valid when attribute is not in inclusion list' do
    subject.foo = 'quux'
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_format_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.validates_format_of(:foo, :with => /^ba.+/i)
    ValidationsTestResource.new
  end

  it 'should be valid when attribute is matching' do
    subject.foo = 'bar'
    subject.should be_valid
  end

  it 'should not be valid when attribute is not matching' do
    subject.foo = 'quux'
    subject.should_not be_valid
  end

  it 'should not be valid when attribute is blank' do
    subject.foo = ''
    subject.should_not be_valid

    subject.foo = nil
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_length_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.new
  end

  describe ':minimum' do
    before { ValidationsTestResource.validates_length_of(:foo, :minimum => 5) }

    it 'should be valid when over the minimum' do
      subject.foo = '123456'
      subject.should be_valid
    end

    it 'should be valid when equal to the minimum' do
      subject.foo = '12345'
      subject.should be_valid
    end

    it 'should not be valid when under the minimum' do
      subject.foo = '1234'
      subject.should_not be_valid
    end
  end

  describe ':maximum' do
    before { ValidationsTestResource.validates_length_of(:foo, :maximum => 5) }

    it 'should be valid when under the maximum' do
      subject.foo = '1234'
      subject.should be_valid
    end

    it 'should be valid when equal to the maximum' do
      subject.foo = '12345'
      subject.should be_valid
    end

    it 'should not be valid when over the maximum' do
      subject.foo = '123456'
      subject.should_not be_valid
    end
  end

  describe ':is' do
    before { ValidationsTestResource.validates_length_of(:foo, :is => 5) }

    it 'should be valid when equal to' do
      subject.foo = '12345'
      subject.should be_valid
    end

    it 'should not be valid when over/under' do
      subject.foo = '1234'
      subject.should_not be_valid

      subject.foo = '123456'
      subject.should_not be_valid
    end
  end

  describe ':within' do
    before { ValidationsTestResource.validates_length_of(:foo, :within => 5..10) }

    it 'should be valid when within range' do
      subject.foo = '12345'
      subject.should be_valid

      subject.foo = '1234567890'
      subject.should be_valid
    end

    it 'should not be valid when over/under' do
      subject.foo = '1234'
      subject.should_not be_valid

      subject.foo = '1234657890a'
      subject.should_not be_valid
    end
  end
end

describe ActiveResource::More::Validations, '.validates_numericality_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.new
  end
end

describe ActiveResource::More::Validations, '.validates_presence_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.new
  end
end

describe ActiveResource::More::Validations, '.validates_uniqueness_of' do
  before { @repairs = record_validations(ValidationsTestResource) }
  after { reset_validations(@repairs) }

  subject do
    ValidationsTestResource.new
  end
end
