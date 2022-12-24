https://github.com/damageboy/lzo2
http://www.oberhumer.com/opensource/lzo/

cd /sources/
wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz

tar -zxf lzo-2.10.tar.gz
cd lzo-2.10
./configure
make
make install

cd /sources/
rm -rf lzo-2.10



#END
