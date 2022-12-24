# http://download.savannah.gnu.org/releases/lzip/
wget http://download.savannah.gnu.org/releases/lzip/lzip-1.23.tar.gz

cd /sources
tar -xvf lzip-1.23.tar.gz

cd lzip-1.23
./configure --prefix=/usr
make
make install

which lzip

cd /sources
rm -rf lzip-1.23

#END
