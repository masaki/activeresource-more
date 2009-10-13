require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/fixtures/test')

describe ActiveResource::More::Finders, '.all' do
  it 'should call .find(:all)' do
    mock(Test).find(:all, {}).times(2)
    Test.all({})
    Test.all # no args
  end
end

describe ActiveResource::More::Finders, '.first' do
  it 'should call .find(:first)' do
    mock(Test).find(:first, {}).times(2)
    Test.first({})
    Test.first # no args
  end
end

describe ActiveResource::More::Finders, '.last' do
  it 'should call .find(:last)' do
    mock(Test).find(:last, {}).times(2)
    Test.last({})
    Test.last # no args
  end
end

describe ActiveResource::More::Finders, '.count' do
  it 'should call .all' do
    mock(Test).all({}).times(2) { [] }
    Test.count({})
    Test.count # no args
  end

  it 'should return length of resources' do
    resources = (1..10).to_a.map { Test.new }
    mock(Test).all({}) { resources }
    Test.count.should == resources.length
  end
end
