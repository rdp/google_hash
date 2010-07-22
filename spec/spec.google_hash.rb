require 'rubygems' if RUBY_VERSION < '1.9'
require 'sane'
require_relative '../ext/google_hash.so'
require 'spec/autorun'

describe "google_hash" do

  before do
   @subject = GoogleHashSparseIntToRuby.new
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
    pending "need"
    # guess these could all be tests, themselves...
    @subject.each_key {}
    @subject.each_value{}
    @subject.each{}
    @subject[33] = 'abc'
    @subject.length.should == 1
    @subject.delete(33).should == 'abc'
    @subject.clear
    @subject.length.should == 0
  end

  it "should not leak" do
    pending "testing if it leaks"
  end
  
  def populate(a)
    a['abc'] = 'def'
    a['bbc'] = 'yoyo'
  end
  
  it "should not die with GC" do
    a = GoogleHashSparseRubyToRuby.new
    populate(a)
    a['abc'].should == 'def'
    a['bbc'].should == 'yoyo'
    GC.start
    a.keys.each{|k| k}
    a.values.each{|v| v}
  end
    

  it "should work with value => value" do
    a = GoogleHashSparseRubyToRuby.new
    a['abc'] = 'def'
    a['abc'].should == 'def'
    a = GoogleHashDenseRubyToRuby.new
    a['abc'] = 'def'
    a['abc'].should == 'def'
  end

  it "should have better namespace" do
    pending do
      GoogleHash::Sparse
    end
  end

  it "should disallow non numeric keys" do
    lambda { @subject['33']}.should raise_error(TypeError)
  end

#  it "should allow for non numeric keys" do
    # todo instantiate new type here...
    # todo allow for floats, ints, symbols, strings [freeze 'em]
    # wait are any of those actually useful tho?
#    @subject['33'] = 33
#    @subject['33'].should == 33
#  end

  it "should return nil if key is absent" do
    @subject[33].should be_nil
  end

  it "should work with 0's" do
   @subject[0] = 'abc'
   @subject[0].should == 'abc'
  end

  it "should do BigNums" do
    pending "if necessary"
  end

  it "should do longs eventually" do
    pending "caring about 64 bit"
  end

  it "should do 63 bit thingy for longs on 64 bit" do
    pending "caring about 64 bit"
  end

  it "should have sets"
  it "should have Set#each"

  it "Set should have #combination calls" do
    @subject[33] = 34
    @subject[36] = 37
    @subject.keys_combination_2{|a, b|
      assert a == 33
      assert b == 36
    }
    
  end
  
  it "Set should have #combination calls with more than one" do
    @subject[1] = 34
    @subject[2] = 37
    @subject[3]= 39
    sum = 0
    count = 0
    @subject.keys_combination_2{|a, b|
      sum += a
      sum += b
      count += 1
    }
    assert count == 3
    assert sum == 1 + 2 + 1 + 3 + 2 + 3
  end

  it "should have an Array for values, keys" do
    @subject[33] = 34
    @subject.keys.should == [33]
    @subject.values.should == [34]
  end
  
  it "should work with all Longs" do
    a = GoogleHashDenseIntToInt.new
    a[3] = 4
    a[3].should == 4
  end
  
  it "should raise on errant values" do
    a = GoogleHashDenseIntToInt.new
    proc { a[3] = 'abc'}.should raise_error
  end
  
  it "should do bignum values as doubles" do
    a = GoogleHashDenseDoubleToInt.new
    a[10000000000000000000] = 1
    a[10000000000000000000].should == 1
  end
  
  it "should do int values as doubles" do
    a = GoogleHashDenseDoubleToInt.new
    a[1] = 1
    a[1].should == 1
  end

  it "should do float values as doubles" do
    a = GoogleHashDenseDoubleToInt.new
    a[1.0] = 1
    a[1.0].should == 1
  end
  
  it "should do bignum to doubles et al" do
    a = GoogleHashDenseDoubleToDouble.new
    a[10000000000000000000] = 1
    a[10000000000000000000].should == 1
    a[1] = 10000000000000000000
    a[1].should == 10000000000000000000
    a[10000000000000000000] = 10000000000000000000
    a[10000000000000000000].should == 10000000000000000000
  end
  
  it "should have really real bignums" do
    fail 'same as above plus'
    a = GoogleHashDenseBignumToRuby.new
    a[10000000000000000000] = 'abc'
  end
  
  it 'should be able to delete bignums without leaking' do
    a = GoogleHashDenseBignumToBignum.new
    100_000.times {
      a[10000000000000000000] = 1
      a.size.should == 1
      a.delete[10000000000000000000]
      a.size.should == 0
    }
    assert OS.rss_bytes < 100_000
  end
  
  it "should have an Enumerator for values, keys, an on demand, getNext enumerator object..."
  
  it "should have a block access for values, keys"
  
  it "should have sets, too, not just hashes"
  
  it "should skip GC when native to native" do
  end

end
