# https://www.linuxfromscratch.org/blfs/view/11.1/general/unzip.html
wget https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget https://www.linuxfromscratch.org/patches/blfs/11.1/unzip-6.0-consolidated_fixes-1.patch --no-check-certificate

begin unzip60 tar.gz
patch -Np1 -i ../unzip-6.0-consolidated_fixes-1.patch
make -f unix/Makefile generic
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

which unzip
finish
