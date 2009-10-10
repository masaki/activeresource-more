require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActiveResource::More::Finders, '.all' do
  it 'should call .find(:all)' do
    mock(TestResource).find(:all, {}).times(2)
    TestResource.all({})
    TestResource.all # no args
  end
end

describe ActiveResource::More::Finders, '.first' do
  it 'should call .find(:first)' do
    mock(TestResource).find(:first, {}).times(2)
    TestResource.first({})
    TestResource.first # no args
  end
end

describe ActiveResource::More::Finders, '.last' do
  it 'should call .find(:last)' do
    mock(TestResource).find(:last, {}).times(2)
    TestResource.last({})
    TestResource.last # no args
  end
end

describe ActiveResource::More::Finders, '.count' do
  it 'should call .all' do
    mock(TestResource).all({}).times(2) { [] }
    TestResource.count({})
    TestResource.count # no args
  end

  it 'should return length of resources' do
    resources = (1..10).to_a.map { TestResource.new }
    mock(TestResource).all({}) { resources }
    TestResource.count.should == resources.length
  end
end
