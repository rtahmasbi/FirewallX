# cpio
wget https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2

begin cpio-2.13 tar.bz2

sed -i '/The name/,+2 d' src/global.c
./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt
make
make install

finish

#END
