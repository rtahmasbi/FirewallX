cd /sources
wget https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2
wget https://www.linuxfromscratch.org/patches/blfs/11.1/lynx-2.8.9rel.1-security_fix-1.patch

# Lynx is a terminal-based web browser for all Linux distributions. It shows the result as plain text on the terminal.

tar xf lynx2.8.9rel.1.tar.bz2
cd lynx2.8.9rel.1
patch -p1 -i ../lynx-2.8.9rel.1-security_fix-1.patch

./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.9rel.1 \
            --with-zlib            \
            --with-bzlib           \
            --with-ssl             \
            --with-screen=ncursesw \
            --enable-locale-charset
make

make install-full
# Configuration Information

which lynx

cd /sources



#END
