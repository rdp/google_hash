./clean.bat
ruby extconf.rb -j8
make -j8
./spec.bat
