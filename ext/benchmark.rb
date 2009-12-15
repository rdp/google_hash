require 'google_hash'
require 'benchmark'

for name in [GoogleHashSparse, GoogleHashDense, Hash] do
 subject = name.new
 puts name,  Benchmark.realtime { 500000.times {|n| subject[n] = 4}}
 puts Benchmark.realtime { subject.each{ }}
end