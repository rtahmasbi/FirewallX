wget https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
wget https://www.linuxfromscratch.org/patches/blfs/11.2/wireless_tools-29-fix_iwlist_scanning-1.patch

tar xf wireless_tools.29.tar.gz # tar xf
cd wireless_tools.29
patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch

make
make PREFIX=/usr INSTALL_MAN=/usr/share/man install

which ifrename
which iwconfig
which iwlist


finish

#END
