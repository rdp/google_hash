require 'mkmf'
require 'erb'
require 'rubygems'
require 'sane'
puts 'got', xsystem("ls")
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

if OS.bits == 32
  unreachable_int = 31
else
  unreachable_int = 63
end

ruby_key =  {:convert_keys_from_ruby => "", :convert_keys_to_ruby => "", :key_type => "VALUE", :unreachable_key => "current_instance"} # TODO NULL is false here?
long_key = {:assert_key_type => 'T_FIXNUM', :convert_keys_from_ruby => "FIX2LONG",
:convert_keys_to_ruby => "LONG2FIX", :key_type => "long", :unreachable_key => "1<<#{unreachable_int}"}
int_key = {:assert_key_type => 'T_FIXNUM', :convert_keys_from_ruby => "FIX2INT",
:convert_keys_to_ruby => "INT2FIX", :key_type => "int", :unreachable_key => "1<<#{unreachable_int}"}


ruby_value =  {:value_type => "VALUE"}
long_value = {:assert_value_type => 'T_FIXNUM', :convert_values_from_ruby => "FIX2LONG",
:convert_values_to_ruby => "LONG2FIX", :value_type => "long"}
int_value = {:assert_value_type => 'T_FIXNUM', :convert_values_from_ruby => "FIX2INT",
:convert_values_to_ruby => "INT2FIX", :value_type => "int"}


long_to_ruby = long_key.merge(ruby_value)
ruby_to_ruby = ruby_key.merge(ruby_value)

long_to_long = long_key.merge(long_value)

init_funcs = []
require 'sane'

for key in [ruby_key, long_key, int_key] do
  for value in [ruby_value, long_value, int_value] do
    options = key.merge(value)
    for type in ['sparse', 'dense'] do


      # create local variables so that the template can look cleaner
      unreachable_key = options[:unreachable_key]
      convert_keys_from_ruby = options[:convert_keys_from_ruby]
      convert_keys_to_ruby = options[:convert_keys_to_ruby]
      key_type = options[:key_type]
      value_type = options[:value_type]
      english_key_type = options[:key_type] == 'VALUE' ? 'ruby' : options[:key_type]
      english_value_type = options[:value_type] == 'VALUE' ? 'ruby' : options[:value_type]

      assert_key_type = options[:assert_key_type]
      convert_values_from_ruby = options[:convert_values_from_ruby]
      convert_values_to_ruby = options[:convert_values_to_ruby]
      assert_value_type = options[:assert_value_type]

      if options[:key_type] == 'VALUE'
        extra_hash_params =  ", hashrb, eqrb"
      else
        extra_hash_params = nil
      end

      template = ERB.new(File.read('template/google_hash.cpp.erb'))
      descriptor = type + '_' + english_key_type + '_to_' + english_value_type;
      File.write(descriptor + '.cpp', template.result(binding))
      init_funcs << "init_" + descriptor
    end
  end
end

# write our Init method

template = ERB.new(File.read('template/main.cpp.erb'))
File.write 'main.cpp', template.result(binding)

create_makefile('google_hash')
