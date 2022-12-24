# https://www.wizcase.com/blog/steps-to-build-linux-vpn/
https://averagelinuxuser.com/linux-vpn-server/
https://openvpn.net/community-resources/how-to/


https://github.com/OpenVPN/openvpn
# source:
https://openvpn.net/community-downloads/

cd /sources/
wget https://swupdate.openvpn.org/community/releases/openvpn-2.5.7.tar.gz


tar -zxf openvpn-2.5.7.tar.gz
cd openvpn-2.5.7
#./configure
# you can install pam as well
./configure --bindir=/usr/bin/  --sbindir=/usr/sbin/ --disable-plugin-auth-pam
make
make install

rm -rf /sources/openvpn-2.5.7
 





# configurations
--nordvpn has lots of examples
https://nordvpn.com/ovpn/

https://charlesreid1.com/wiki/OpenVPN/Static_Key





#END
