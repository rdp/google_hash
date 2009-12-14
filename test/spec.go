require 'sane'

describe GoogleHashSpace do

  before do
   @subject = GoogleHashSpace.new
  end

  it "should be instantiable" do
    # nothing
  end

  it "should allow you to set a key" do
    @subject[33] = 'abc'
  end

  it "should allow you to retrieve a key" do
    @subject[33] = 'abc'
    @subject[33].should == 'abc'
  end

  it "should allow you to iterate" do
   @subject[33] = 'abc'
   @subject[44] = 'def'
   all_got = []
   @subject.each{|k, v|
    all_got << v
   }
   assert all_got.sort == ['abc', 'def']
  end

  it "should have all the methods desired" do
    # guess these could all be tests, themselves...
    @subject.each_key {}
    @subject.each_value{}
    @subject.each{}
    @subject.delete(33)
    @subject.clear
    @subject.length.should == 0
  end

  it "should not leak" do
    raise 'not done'
  end

  it "should have better namespace" do
    GoogleHash::Space
  end

  it "should disallow non numeric keys" do
    @subject['33'].should raise_exception
  end

  it "should allow for non numeric keys" do
    # todo instantiate new type here...
    # todo allow for floats, ints, symbols, strings [freeze 'em]
    # wait are any of those actually useful tho?
    @subject['33'] = 33
    @subject['33'].should == 33
  end

  # todo do the non sparse, too...

end
