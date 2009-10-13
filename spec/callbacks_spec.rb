require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/test')

describe ActiveResource::More::Callbacks, '#create' do
  subject { Test.new }

  it 'should call before_create and after_create' do
    mock(subject).before_create
    mock(subject).after_create

    subject.mock_post!
    subject.instance_eval { create }
  end
end

describe ActiveResource::More::Callbacks, '#update' do
  subject { Test.new(:id => 1) }

  it 'should call before_update and after_update' do
    mock(subject).before_update
    mock(subject).after_update

    subject.mock_put!
    subject.instance_eval { update }
  end
end

describe ActiveResource::More::Callbacks, '#destroy' do
  subject { Test.new(:id => 1) }

  it 'should call before_destroy and after_destroy' do
    mock(subject).before_destroy
    mock(subject).after_destroy

    subject.mock_delete!
    subject.destroy
  end
end

describe ActiveResource::More::Callbacks, '#save' do
  describe 'when called from new resource:' do
    subject { Test.new }

    it 'should call save and create hooks' do
      mock(subject).before_save
      mock(subject).before_create
      mock(subject).after_create
      mock(subject).after_save
      dont_allow(subject).before_update
      dont_allow(subject).after_update

      subject.mock_post!
      subject.save
    end
  end

  describe 'when called from existing resource:' do
    subject { Test.new(:id => 1) }

    it 'should call save and update hooks' do
      mock(subject).before_save
      mock(subject).before_update
      mock(subject).after_update
      mock(subject).after_save
      dont_allow(subject).before_create
      dont_allow(subject).after_create

      subject.mock_put!
      subject.save
    end
  end
end
