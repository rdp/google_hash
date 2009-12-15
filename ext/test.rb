require 'google_hash'
a = GoogleHashSmall.new
puts
a[3] = 4

require 'benchmark'
b = {}
puts Benchmark.realtime { 1000.times { 1000.times {|n| b[n] = 4}}}
puts Benchmark.realtime { 1000.times { 1000.times {|n| a[n] = 4}}}

