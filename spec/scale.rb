require 'sane'
require_relative 'benchmark'

for n in [100_000, 500_000, 1_000_000, 10_000_000, 150000000] do # 1_000_000 is about the last one that doesn't have an awful each
 go n
end
