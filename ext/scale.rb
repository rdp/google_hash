require 'sane'
require_rel 'benchmark'
for n in [100, 1000, 100000, 1000000, 1000000, 100000000, 500000000] do
 go n
end