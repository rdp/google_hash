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
# ltodo 64 bit compat...

for type, setup_code in {'sparse' => nil, 'dense' => 'set_empty_key(1<<31);' } do
  template = ERB.new(File.read('template/go.cpp'))
  File.write(type.to_s + '.cpp', template.result(binding))
end

create_makefile('google_hash')
