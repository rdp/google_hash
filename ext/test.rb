require 'google_hash'
require 'benchmark'

for name in [Hash, GoogleHashSparse, GoogleHashDense] do
 subject = name.new
 puts name,  Benchmark.realtime { 1000.times { 1000.times {|n| subject[n] = 4}}}
end


