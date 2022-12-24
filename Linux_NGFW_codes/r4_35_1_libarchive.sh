# https://www.linuxfromscratch.org/blfs/view/svn/general/libarchive.html
wget https://github.com/libarchive/libarchive/releases/download/v3.6.1/libarchive-3.6.1.tar.xz

tar -xvf libarchive-3.6.1.tar.xz
cd libarchive-3.6.1
sed '/linux\/fs\.h/d' -i libarchive/archive_read_disk_posix.c
./configure --prefix=/usr --disable-static
make
make install

which bsdcat
