# https://www.linuxfromscratch.org/blfs/view/stable-systemd/general/libxslt.html
wget https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.36.tar.xz --no-check-certificate

begin libxslt-1.1.36 tar.xz
sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml}
./configure --prefix=/usr --disable-static --without-python
make -j8
make install
which xsltproc
finish
