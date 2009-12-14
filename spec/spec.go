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

end