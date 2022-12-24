# ethtool
# wget https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-5.16.tar.xz

# requires libmnl

begin ethtool-5.16 tar.xz
./configure --prefix=/usr
MAKETUNING=-j8
make $(MAKETUNING)
make install

which ethtool 

finish
