require 'sane'
require_relative '../ext/google_hash'
require 'benchmark'
if !ARGV[0].in? ['sparse', 'dense', 'ruby']
  puts 'syntax: bench_gc.rb sparse|dense|ruby'
  exit 1
end

p ARGV[0]
if ARGV[0] == 'sparse'
 a = GoogleHashSparseIntToInt.new 
elsif ARGV[0] == 'dense'
 a = GoogleHashDenseIntToInt.new
elsif ARGV[0] == 'ruby'
 a = Hash.new
else
  throw 'never get here'
end

took = Benchmark.realtime { 2_000_000.times {|i| a[i] = i} }

p 'took second', took.group_digits, 'mem used:', OS.rss_bytes.group_digits, 'each gc now takes', Benchmark.realtime {GC.start}.group_digits, ObjectSpace.count_objects