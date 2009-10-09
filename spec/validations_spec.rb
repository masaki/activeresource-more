require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveResource::More::Validations, '.validates_acceptance_of' do
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_acceptance_of(:foo, :baz)
    TestResource.new
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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_confirmation_of(:foo)
    TestResource.new
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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_exclusion_of(:foo, :in => %w[ bar baz ])
    TestResource.new
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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_inclusion_of(:foo, :in => %w[ bar baz ])
    TestResource.new
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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_format_of(:foo, :with => /^ba.+/i)
    TestResource.new
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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.new
  end

  describe ':minimum' do
    before { TestResource.validates_length_of(:foo, :minimum => 5) }

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
    before { TestResource.validates_length_of(:foo, :maximum => 5) }

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
    before { TestResource.validates_length_of(:foo, :is => 5) }

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
    before { TestResource.validates_length_of(:foo, :within => 5..10) }

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
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_numericality_of(:foo)
    TestResource.new
  end

  it 'should be valid when attribute is Fixnum' do
    subject.foo = 1
    subject.should be_valid

    subject.foo = 1.00
    subject.should be_valid
  end

  it 'should be valid when attribute is String of number' do
    subject.foo = '1'
    subject.should be_valid

    subject.foo = '+1'
    subject.should be_valid

    subject.foo = '-1'
    subject.should be_valid

    subject.foo = '1.00'
    subject.should be_valid
  end

  it 'should not be valid when attribute is String' do
    subject.foo = 'bar'
    subject.should_not be_valid
  end

  describe ':only_integer' do
    subject do
      TestResource.validates_numericality_of(:foo, :only_integer => true)
      TestResource.new
    end

    it 'should be valid when attribute is integer' do
      subject.foo = 1
      subject.should be_valid

      subject.foo = '1'
      subject.should be_valid

      subject.foo = -1
      subject.should be_valid
    end

    it 'should not be valid when attribute is not integer' do
      subject.foo = 1.00
      subject.should_not be_valid
    end
  end

  describe ':equal_to' do
    subject do
      TestResource.validates_numericality_of(:foo, :equal_to => 1)
      TestResource.new
    end

    it 'should be valid when attribute is equal to' do
      subject.foo = 1
      subject.should be_valid

      subject.foo = '1'
      subject.should be_valid

      subject.foo = 1.00
      subject.should be_valid
    end

    it 'should not be valid when attribute is not equal to' do
      subject.foo = 2
      subject.should_not be_valid

      subject.foo = '3'
      subject.should_not be_valid

      subject.foo = 1.23
      subject.should_not be_valid
    end
  end

  describe ':greater_than' do
    subject do
      TestResource.validates_numericality_of(:foo, :greater_than => 5)
      TestResource.new
    end

    it 'should be valid when attribute is greater than' do
      subject.foo = 6
      subject.should be_valid

      subject.foo = 5.01
      subject.should be_valid
    end

    it 'should not be valid when attribute is not greater than' do
      subject.foo = 5
      subject.should_not be_valid

      subject.foo = 4
      subject.should_not be_valid

      subject.foo = 5.00
      subject.should_not be_valid
    end
  end

  describe ':greater_than_or_equal_to' do
    subject do
      TestResource.validates_numericality_of(:foo, :greater_than_or_equal_to => 5)
      TestResource.new
    end

    it 'should be valid when attribute is greater than or equal to' do
      subject.foo = 6
      subject.should be_valid

      subject.foo = 5.01
      subject.should be_valid

      subject.foo = 5
      subject.should be_valid

      subject.foo = 5.00
      subject.should be_valid
    end

    it 'should not be valid when attribute is not greater than or equal to' do
      subject.foo = 4
      subject.should_not be_valid
    end
  end

  describe ':less_than' do
    subject do
      TestResource.validates_numericality_of(:foo, :less_than => 5)
      TestResource.new
    end

    it 'should be valid when attribute is less than' do
      subject.foo = 4
      subject.should be_valid

      subject.foo = 4.99
      subject.should be_valid
    end

    it 'should not be valid when attribute is not less than' do
      subject.foo = 5
      subject.should_not be_valid

      subject.foo = 6
      subject.should_not be_valid

      subject.foo = 5.00
      subject.should_not be_valid
    end
  end

  describe ':less_than_or_equal_to' do
    subject do
      TestResource.validates_numericality_of(:foo, :less_than_or_equal_to => 5)
      TestResource.new
    end

    it 'should be valid when attribute is less than or equal to' do
      subject.foo = 4
      subject.should be_valid

      subject.foo = 4.99
      subject.should be_valid

      subject.foo = 5
      subject.should be_valid

      subject.foo = 5.00
      subject.should be_valid
    end

    it 'should not be valid when attribute is not less than or equal to' do
      subject.foo = 6
      subject.should_not be_valid
    end
  end

  describe ':odd' do
    subject do
      TestResource.validates_numericality_of(:foo, :odd => true)
      TestResource.new
    end

    it 'should be valid when attribute is odd number' do
      subject.foo = 1
      subject.should be_valid
    end

    it 'should not be valid when attribute is even number' do
      subject.foo = 2
      subject.should_not be_valid
    end
  end

  describe ':even' do
    subject do
      TestResource.validates_numericality_of(:foo, :even => true)
      TestResource.new
    end

    it 'should be valid when attribute is even number' do
      subject.foo = 2
      subject.should be_valid
    end

    it 'should not be valid when attribute is odd number' do
      subject.foo = 1
      subject.should_not be_valid
    end
  end
end

describe ActiveResource::More::Validations, '.validates_presence_of' do
  before { @repairs = record_validations(TestResource) }
  after { reset_validations(@repairs) }

  subject do
    TestResource.validates_presence_of(:foo)
    TestResource.new
  end

  it 'should be valid when attribute is present' do
    subject.foo = 'bar'
    subject.should be_valid
  end

  it 'should not be valid when attribute is blank' do
    subject.foo = ''
    subject.should_not be_valid

    subject.foo = nil
    subject.should_not be_valid
  end
end

describe ActiveResource::More::Validations, '.validates_uniqueness_of' do
  it 'should raise NoMethodError because this method is not implemented' do
    lambda {
      TestResource.validates_uniqueness_of
    }.should raise_error(NoMethodError)
  end
end
