require './google_hash'
require 'benchmark'
require 'hitimes'

def measure
 Hitimes::Interval.measure { yield }
end

def meas string
 puts "% -23s" % string + measure { yield }.to_s
end

def go num
  puts num
  # get all existing
  all = [Hash] + Object.constants.grep(/Goog/).reject{|n| n == :GoogleHash}.map{|n| eval n}

  for name in all do
    GC.start
    subject = name.new
    puts
    puts name

    subject = name.new
    meas( "populate string ") { num.times {|n| subject['abc'] = 4 } } rescue nil
    subject = name.new
    meas( "populate symbol") { num.times {|n| subject[:abc] = 4} } rescue nil

    meas( "populate int") { num.times {|n| subject[n] = 4}}
    meas("each") { subject.each{|k, v| } }

    begin
      subject = name.new
      subject[3] = 4
      meas("lookup int") { num.times {|n| subject[3]}}
      subject['abc'] = 3
      subject[:abc] = 3

      meas("lookup string")  { num.times {|n| subject['abc']}}
      meas( "lookup symbol" ) { num.times {|n| subject[:abc]}}
    rescue
    end
  end
end

num = 200_000
go num if $0 ==__FILE__
