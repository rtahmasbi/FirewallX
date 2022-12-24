wget https://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2

# libmnl

begin libmnl-1.0.4 tar.bz2
./configure --prefix=/usr
make -j8
make install

# libmnl.so


finish
