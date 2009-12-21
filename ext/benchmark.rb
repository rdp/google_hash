require './google_hash'
require 'benchmark'
require 'hitimes'

def measure
 Hitimes::Interval.measure { yield }
end

def go num
  puts
  puts num
  # get all existing
  all =  Object.constants.grep(/Goog/).reject{|n| n == :GoogleHash}.map{|n| eval n} + [Hash]

  for name in all do
    GC.start
    subject = name.new
    puts name, measure { num.times {|n| subject[n] = 4}}.to_s + "   (populate)"
    puts measure { subject.each{|k, v| }}.to_s + " (each)"
    puts measure { num.times {|n| subject[n]}}.to_s + " (lookup)"

  end
end

num = 500_000
go num if $0 ==__FILE__
