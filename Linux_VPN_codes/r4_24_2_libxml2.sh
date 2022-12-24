
# https://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html
wget https://download.gnome.org/sources/libxml2/2.10/libxml2-2.10.2.tar.xz --no-check-certificate
begin libxml2-2.10.2 tar.xz
./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.10.2
make -j8
make install
