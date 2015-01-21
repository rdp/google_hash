./clean.bat
ruby extconf.rb -j8
make -j 8
./spec.bat
