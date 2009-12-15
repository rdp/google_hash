require 'mkmf'
require 'rubygems'
require 'sane' # dependency!


# build google's lib locally...

dir = Dir.pwd
Dir.chdir 'sparsehash-1.5.2' do
  dir = dir + '/local_installed'
  command = "sh configure --prefix=#{dir} && make && make install"
  puts command
  system command unless File.directory?(dir)
end

$CFLAGS += " -I./local_installed/include "

# create our wrapper files...
require 'erb'
for type in ['sparse', 'dense'] do
  x = 42
  template = ERB.new(File.read('template/go.cpp'))
  File.write(type + '.cpp', template.result(binding))
end

create_makefile('google_hash')
