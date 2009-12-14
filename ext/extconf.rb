require 'mkmf'
require 'rubygems'
require 'sane'

# Give it a name
extension_name = 'mytest'

# The destination
dir_config(extension_name)

$CFLAGS += " -I./local_installed "

dir = Dir.pwd
Dir.chdir 'sparsehash-1.5.2' do
  dir = dir + '/local_installed'
  command = "sh configure --prefix=#{dir} && make && make install"
  puts command
  system command
end

create_makefile(extension_name)
