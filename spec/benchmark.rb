require 'sane' # gem
require_relative '../ext/google_hash'
require 'benchmark'
require 'hitimes' # gem

def measure
 Hitimes::Interval.measure { yield }
end

def meas string
 time_took = measure { yield }
 puts "% -23s %.03f" % [string, time_took]
end

def go num
  puts RUBY_DESCRIPTION
  puts "inserting #{num} objects"
  puts "remember that these may be more RAM space efficient than ruby's standard hash, as well, esp. the sparse hash--see the file bench_gc.rb"
  puts "double is like float, long is like a large int"
  # get all existing
  all_google_hashmap_classes = Object.constants.grep(/^GoogleHash.*/).reject{|n| n == :GoogleHash}.map{|n| eval n.to_s}
  all = all_google_hashmap_classes + [Hash]

  for name in all do
    GC.start # try to clear the previous run's hash from memory :)
    GC.disable # don't let this taint runs
    subject = name.new
    puts
	if name == Hash
      puts "Ruby Standard Hash"
	else
	  puts name
	end

    subject = name.new
    meas( "populate string ") { num.times {|n| subject['abc'] = 4 } } rescue nil
    subject = name.new
    meas( "populate symbol") { num.times {|n| subject[:abc] = 4} } rescue nil

    meas( "populate integer") { num.times {|n| subject[n] = 4}}
    meas("#each") { subject.each{|k, v| } }

    begin
      subject = name.new
      subject[3] = 4
      meas("lookup int") { num.times {|n| subject[3]}}
      subject['abc'] = 3
      subject[:abc] = 3

      meas("lookup string")  { num.times {|n| subject['abc']}}
      meas( "lookup symbol" ) { num.times {|n| subject[:abc]}}
    rescue # most don't support these...
    end
  end
end

num = 400_000
go num if $0 ==__FILE__
