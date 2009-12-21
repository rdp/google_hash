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

# my goal is...ruby friendly hashers

int_to_ruby =  {:convert_keys_from_ruby => "FIX2INT", :convert_keys_to_ruby => "INT2FIX", :key_type => "int", :value_type => "VALUE", :english_value_type => "ruby"}
ruby_to_ruby = {:convert_keys_from_ruby => "", :convert_keys_to_ruby => "", :key_type => "VALUE", :value_type => "VALUE"}


init_funcs = []


for options in [int_to_ruby] do
 for type, setup_code in {'sparse' => nil, 'dense' => 'set_empty_key(1<<31);' } do

  # create local variables so that the template can look cleaner
  setup_code = options[:setup_code]
  convert_keys_from_ruby = options[:convert_keys_from_ruby]
  convert_keys_to_ruby = options[:convert_keys_to_ruby]
  key_type = options[:key_type]
  value_type = options[:value_type]
  english_key_type = options[:key_type] == 'VALUE' ? 'ruby' : options[:key_type]
  english_value_type = options[:value_type] == 'VALUE' ? 'ruby' : options[:value_type]
  
  if options[:key_type] == 'VALUE'
    extra_hash_params =  ", hashrb, eqrb"  # use these methods for comparison
    # ltodo is that the right hash -- is is type_t
  end
  
  template = ERB.new(File.read('template/google_hash.cpp.erb'))  
  descriptor = type + '_' + english_key_type + '_to_' + english_value_type;
  File.write(descriptor + '.cpp', template.result(binding))
  init_funcs << "init_" + descriptor
 end
end

# write our Init method

template = ERB.new(File.read('template/main.cpp.erb'))  
File.write 'main.cpp', template.result(binding)

create_makefile('google_hash')
