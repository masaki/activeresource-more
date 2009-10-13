require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/person')

describe ActiveResource::More::Validations do
  before(:each) { @repairs = record_validations(User) }
  after(:each)  { reset_validations(@repairs)         }

  describe '.validates_acceptance_of' do
    subject do
      User.validates_acceptance_of(:terms_of_service)
      User.new
    end

    it 'should define unregistered column attribute accessor' do
      subject.should be_respond_to(:terms_of_service)
      subject.terms_of_service.should be_nil
    end

    it 'should be valid when attribute is undefined' do
      subject.terms_of_service = nil
      subject.should be_valid
    end

    it 'should be valid when attribute is present' do
      subject.terms_of_service = '1'
      subject.should be_valid
    end

    it 'should not be valid when attribute is blank' do
      subject.terms_of_service = ''
      subject.should_not be_valid
    end
  end

  describe '.validates_confirmation_of' do
    subject do
      User.validates_confirmation_of(:password)
      User.new
    end

    it 'should define confirm accessor' do
      subject.should be_respond_to(:password_confirmation)
      subject.password_confirmation.should be_nil
    end

    it 'should be valid when each attributes are blank' do
      subject.password              = ''
      subject.password_confirmation = ''
      subject.should be_valid
    end

    it 'should be valid when each attributes are equivalent' do
      subject.password              = 'password_string'
      subject.password_confirmation = 'password_string'
      subject.should be_valid
    end

    it 'should be valid when confirmation attribute is undefined' do
      subject.password              = 'password_string'
      subject.password_confirmation = nil
      subject.should be_valid
    end

    it 'should not be valid when each attributes are different' do
      subject.password              = 'password_string'
      subject.password_confirmation = 'wrong_password_string'
      subject.should_not be_valid
    end
  end

  describe '.validates_exclusion_of' do
    subject do
      User.validates_exclusion_of(:name, :in => %w[ foo bar baz ])
      User.new
    end

    it 'should be valid when attribute is not in exclusion list' do
      subject.name = 'quux'
      subject.should be_valid
    end

    it 'should not be valid when attribute is in exclusion list' do
      subject.name = 'bar'
      subject.should_not be_valid
    end
  end

  describe '.validates_inclusion_of' do
    subject do
      User.validates_inclusion_of(:name, :in => %w[ foo bar baz ])
      User.new
    end

    it 'should be valid when attribute is in inclusion list' do
      subject.name = 'bar'
      subject.should be_valid
    end

    it 'should not be valid when attribute is not in inclusion list' do
      subject.name = 'quux'
      subject.should_not be_valid
    end
  end

  describe '.validates_format_of' do
    subject do
      User.validates_format_of(:email, :with => /^.+\@.+/i)
      User.new
    end

    it 'should be valid when attribute is matching' do
      subject.email = 'foobar@example.com'
      subject.should be_valid
    end

    it 'should not be valid when attribute is not matching' do
      subject.email = 'quux__at__example__dot__com'
      subject.should_not be_valid
    end

    it 'should not be valid when attribute is blank' do
      subject.email = ''
      subject.should_not be_valid

      subject.email = nil
      subject.should_not be_valid
    end
  end

  describe '.validates_length_of' do
    subject { User.new }

    describe '(:minimum)' do
      before { User.validates_length_of(:name, :minimum => 6) }

      it 'should be valid when over the minimum' do
        subject.name = 'foobarbaz'
        subject.should be_valid
      end
      it 'should be valid when equal to the minimum' do
        subject.name = 'foobar'
        subject.should be_valid
      end
      it 'should not be valid when under the minimum' do
        subject.name = 'quux'
        subject.should_not be_valid
      end
    end

    describe '(:maximum)' do
      before { User.validates_length_of(:name, :maximum => 6) }

      it 'should be valid when under the maximum' do
        subject.name = 'quux'
        subject.should be_valid
      end
      it 'should be valid when equal to the maximum' do
        subject.name = 'foobar'
        subject.should be_valid
      end
      it 'should not be valid when over the maximum' do
        subject.name = 'foobarbaz'
        subject.should_not be_valid
      end
    end

    describe '(:is)' do
      before { User.validates_length_of(:name, :is => 6) }

      it 'should be valid when equal to' do
        subject.name = 'foobar'
        subject.should be_valid
      end
      it 'should not be valid when under' do
        subject.name = 'quux'
        subject.should_not be_valid
      end
      it 'should not be valid when over' do
        subject.name = 'foobarbaz'
        subject.should_not be_valid
      end
    end

    describe '(:within)' do
      before { User.validates_length_of(:name, :within => 7..10) }

      it 'should be valid when within range' do
        subject.name = 'foobarbaz'
        subject.should be_valid

        subject.name = 'barbazquux'
        subject.should be_valid
      end
      it 'should not be valid when under range' do
        subject.name = 'foobar'
        subject.should_not be_valid
      end
      it 'should not be valid when over range' do
        subject.name = 'foobarbazquux'
        subject.should_not be_valid
      end
    end
  end

  describe '.validates_numericality_of' do
    describe '(no options)' do
      subject do
        User.validates_numericality_of(:age)
        User.new
      end

      it 'should be valid when attribute is Fixnum' do
        [ 20, 20.00, +20, -20 ].each do |value|
          subject.age = value
          subject.should be_valid

          subject.age = value.to_s
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is String' do
        subject.age = 'nineteen years old'
        subject.should_not be_valid
      end
    end

    describe '(:only_integer)' do
      subject do
        User.validates_numericality_of(:age, :only_integer => true)
        User.new
      end

      it 'should be valid when attribute is integer' do
        [ 20, '20', -5 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not integer' do
        [ 20.0, '20.0' ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:equal_to)' do
      subject do
        User.validates_numericality_of(:age, :equal_to => 20)
        User.new
      end

      it 'should be valid when attribute is equal to' do
        [ 20, '20', 20.0 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not equal to' do
        [ 18, '25', 21.0 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:greater_than)' do
      subject do
        User.validates_numericality_of(:age, :greater_than => 18)
        User.new
      end

      it 'should be valid when attribute is greater than' do
        [ 19, 18.1 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not greater than' do
        [ 18, '16', 17.9 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:greater_than_or_equal_to)' do
      subject do
        User.validates_numericality_of(:age, :greater_than_or_equal_to => 18)
        User.new
      end

      it 'should be valid when attribute is greater than or equal to' do
        [ 19, 18.1, 18, 18.0 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not greater than or equal to' do
        [ 17, 17.9 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:less_than)' do
      subject do
        User.validates_numericality_of(:age, :less_than => 18)
        User.new
      end

      it 'should be valid when attribute is less than' do
        [ 17, 17.9 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not less than' do
        [ 19, 18.1, 18, 18.0 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:less_than_or_equal_to)' do
      subject do
        User.validates_numericality_of(:age, :less_than_or_equal_to => 18)
        User.new
      end

      it 'should be valid when attribute is less than or equal to' do
        [ 18, '16', 17.9 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is not less than or equal to' do
        [ 19, 18.1 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:odd)' do
      subject do
        User.validates_numericality_of(:age, :odd => true)
        User.new
      end

      it 'should be valid when attribute is odd number' do
        [ 1, '3', 5.0 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is even number' do
        [ 2, '4', 6.0 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end

    describe '(:even)' do
      subject do
        User.validates_numericality_of(:age, :even => true)
        User.new
      end

      it 'should be valid when attribute is even number' do
        [ 2, '4', 6.0 ].each do |value|
          subject.age = value
          subject.should be_valid
        end
      end

      it 'should not be valid when attribute is odd number' do
        [ 1, '3', 5.0 ].each do |value|
          subject.age = value
          subject.should_not be_valid
        end
      end
    end
  end

  describe '.validates_presence_of' do
    subject do
      User.validates_presence_of(:display_name)
      User.new
    end

    it 'should be valid when attribute is present' do
      subject.display_name = 'my name'
      subject.should be_valid
    end

    it 'should not be valid when attribute is blank' do
      subject.display_name = ''
      subject.should_not be_valid

      subject.display_name = nil
      subject.should_not be_valid
    end
  end

  describe '.validates_uniqueness_of' do
    it 'should raise NoMethodError because this method is not implemented' do
      lambda {
        User.validates_uniqueness_of
      }.should raise_error(NoMethodError)
    end
  end
end
