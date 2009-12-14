require 'mkmf'

# Give it a name
extension_name = 'mytest'

# The destination
dir_config(extension_name)

$CFLAGS += " -I/C/go/include "

# Do the work
create_makefile(extension_name)