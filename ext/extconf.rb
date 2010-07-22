require 'mkmf'
require 'erb'
require 'rubygems'
require 'sane'

# re-build google's lib locally...

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

ruby_key =  {:convert_keys_from_ruby => "", :convert_keys_to_ruby => "", :key_type => "VALUE", :english_key_type => "ruby",
  :extra_hash_params => ", hashrb, eqrb", :unreachable_key => "current_instance"} # TODO NULL is false here?
int_key = {:assert_key_type => 'T_FIXNUM', :convert_keys_from_ruby => "FIX2INT",
  :convert_keys_to_ruby => "INT2FIX", :key_type => "int", :unreachable_key => "1<<#{unreachable_int}"}
# "long" is not useful to us since it's the same as int...
bignum_key = {:assert_key_type => ['T_BIGNUM', 'T_FIXNUM'], :convert_keys_from_ruby => "rb_big2dbl",
  :convert_keys_to_ruby => "rb_dbl2big", :key_type => "double", :unreachable_key => "1<<#{unreachable_int}",  # LODO is this a bignum value though?
  :extra_hash_params => ", hashdouble, eqdouble",
  :extra_set_code => "if(TYPE(set_this) == T_FIXNUM)\nset_this = rb_int2big(set_this);",
  :extra_get_code => "if(TYPE(get_this) == T_FIXNUM) \n get_this = rb_int2big(get_this);"
}  # fixnum's can never be zero...


ruby_value = {:value_type => "VALUE", :english_value_type => "ruby"}
int_value = {:assert_value_type => 'T_FIXNUM', :convert_values_from_ruby => "FIX2INT",
  :convert_values_to_ruby => "INT2FIX", :value_type => "int"}

  #bignum_value = {:assert_value_type => 'T_BIGNUM', :convert_values_from_ruby => "rb_big2dbl",
  #:convert_values_to_ruby => "rb_dbl2big", :value_type => "double", }

init_funcs = []

for key in [ruby_key, int_key, bignum_key] do
  for value in [ruby_value, int_value] do
    options = key.merge(value)
    for type in ['sparse', 'dense'] do

      # create local variables so that the template can look cleaner
      unreachable_key = options[:unreachable_key]
      convert_keys_from_ruby = options[:convert_keys_from_ruby]
      convert_keys_to_ruby = options[:convert_keys_to_ruby]
      key_type = options[:key_type]
      value_type = options[:value_type]
      english_key_type = options[:english_key_type] || options[:key_type]
      english_value_type = options[:english_value_type] || options[:value_type]

      
      assert_key_type = [options[:assert_key_type]].flatten[0]
      assert_key_type2 = [options[:assert_key_type]].flatten[1]
      convert_values_from_ruby = options[:convert_values_from_ruby]
      convert_values_to_ruby = options[:convert_values_to_ruby]
      assert_value_type = options[:assert_value_type]

      extra_hash_params = options[:extra_hash_params]
      
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
