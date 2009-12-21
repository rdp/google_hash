require 'mkmf'
require 'erb'
require 'rubygems'
require 'sane'

# build google's lib locally...

dir = Dir.pwd
Dir.chdir 'sparsehash-1.5.2' do
  dir = dir + '/local_installed'
  command = "sh configure --prefix=#{dir} && make && make install"
  puts command
  # only if necessary
  system command unless File.directory?(dir)
end

$CFLAGS += " -I./local_installed/include "

if RUBY_VERSION < '1.9'
 # appears to link using gcc on 1.8 [mingw at least]
 $LDFLAGS += " -lstdc++ "
end

# create our files...
# currently we're int only...hmm...
# ltodo if I am using longs, this 31 needs to be a 63 on 64 bit machines...
# if I ever use longs :)

int_type = {:convert_keys_from_ruby => "FIX2INT", :convert_keys_to_ruby => "INT2FIX", :key_type => "int", :value_type => "ruby"}


for type, options in {'sparse' => int_type, 'dense' => int_type.merge(:setup_code => 'set_empty_key(1<<31);') } do
  
  # create local variables so that the template can look cleaner
  setup_code = options[:setup_code]
  convert_keys_from_ruby = options[:convert_keys_from_ruby]
  convert_keys_to_ruby = options[:convert_keys_to_ruby]
  key_type = options[:key_type]
  value_type = options[:value_type]
  
  template = ERB.new(File.read('template/google_hash.cpp.erb'))  
  File.write(type.to_s + '.cpp', template.result(binding))
end

create_makefile('google_hash')
