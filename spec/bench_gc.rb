
require 'google_hash'
require 'sane'
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
took = Benchmark.realtime { 200_00000.times {|i| a[i] = i} }

 p 'took', took.group_digits, OS.rss_bytes.group_digits, Benchmark.realtime { GC.start}.group_digits, ObjectSpace.count_objects