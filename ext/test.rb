require 'google_hash'
require 'benchmark'

for name in [GoogleHashSparse, GoogleHashDense] do
 GC.start
 subject = name.new
 GC.start
 puts name,  Benchmark.realtime { 1000.times { 1000.times {|n| subject[n] = 4}}}
 GC.start
 subject.each{|*args| puts 'args out:', *args }
end


