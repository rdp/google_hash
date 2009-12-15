require 'mkmf'
require 'rubygems'
require 'sane'

# build google's lib locally...
dir = Dir.pwd
Dir.chdir 'sparsehash-1.5.2' do
  dir = dir + '/local_installed'
  command = "sh configure --prefix=#{dir} && make && make install"
  puts command
  #system command
end

$CFLAGS += " -I./local_installed/include "
create_makefile('google_hash')
