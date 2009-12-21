rm *.cpp 
ruby extconf.rb && make clean && make && ruby ..\spec\spec.google_hash.rb