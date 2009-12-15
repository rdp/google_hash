require './google_hash'
require 'benchmark'

for name in [GoogleHashSparse, GoogleHashDense, Hash] do
 subject = name.new
 puts name, Benchmark.realtime { 500000.times {|n| subject[n] = 4}}.to_s + "   (populate)"
 puts Benchmark.realtime { subject.each{|k, v| }}.to_s + " (each)", ''

end
