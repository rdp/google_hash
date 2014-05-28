puts 'to run different types, modify source code'

require 'sane'
require_relative '../ext/google_hash'
require 'benchmark'
sparse = false
dense = false
ruby = true
if sparse
 a = GoogleHashSparseIntToInt.new
 p 'sparse'
elsif dense
 p 'dense'
 a = GoogleHashDenseIntToInt.new
else
 p 'ruby'
 a = []
end
took = Benchmark.realtime { 20_000_000.times {|i| a[i] = i} }

p 'took second', took.group_digits, 'mem used:', OS.rss_bytes.group_digits, 'gc now takes', Benchmark.realtime {GC.start}.group_digits, ObjectSpace.count_objects