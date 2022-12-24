# libaio
# https://www.linuxfromscratch.org/blfs/view/11.1/general/libaio.html
wget https://ftp.debian.org/debian/pool/main/liba/libaio/libaio_0.3.112.orig.tar.xz

mv libaio_0.3.112.orig.tar.xz libaio-0.3.112.tar.xz
begin libaio-0.3.112 tar.xz

sed -i '/install.*libaio.a/s/^/#/' src/Makefile
make
sed 's/-Werror//' -i harness/Makefile

make install

#libaio.so



finish



#END
