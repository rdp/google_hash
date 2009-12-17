require './google_hash'
require 'benchmark'

num = 500000
puts num

for name in [GoogleHashSparse, GoogleHashDense, Hash] do
  GC.start
   subject = name.new

   puts name, Benchmark.realtime { num.times {|n| subject[n] = 4}}.to_s + "   (populate)"
   puts Benchmark.realtime { subject.each{|k, v| }}.to_s + " (each)"
   puts Benchmark.realtime { num.times {|n| subject[n]}}.to_s + " (lookup)"

end
