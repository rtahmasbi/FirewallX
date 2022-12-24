wget https://roy.marples.name/downloads/dhcpcd/dhcpcd-9.4.1.tar.xz


begin dhcpcd-9.4.1 tar.xz
install  -v -m700 -d /var/lib/dhcpcd

groupadd -g 52 dhcpcd
useradd  -c 'dhcpcd PrivSep' \
         -d /var/lib/dhcpcd  \
         -g dhcpcd           \
         -s /bin/false     \
         -u 52 dhcpcd

chown    -v dhcpcd:dhcpcd /var/lib/dhcpcd 
sed '/Deny everything else/i SECCOMP_ALLOW(__NR_getrandom),' \
    -i src/privsep-linux.c
#


./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd      \
            --runstatedir=/run           \
            --privsepuser=dhcpcd

make


make install

make install-service-dhcpcd

sed -i "s;/run/dhcpcd-;/run/dhcpcd/;g" /lib/services/dhcpcd
cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT="yes"
IFACE="eth0"
SERVICE="dhcpcd"
DHCP_START="-b -q <insert appropriate start options here>"
DHCP_STOP="-k <insert additional stop options here>"
EOF

cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT="yes"
IFACE="eth0"
SERVICE="dhcpcd"
DHCP_START="-b -q -S ip_address=192.168.0.10/24 -S routers=192.168.0.1"
DHCP_STOP="-k"
EOF


cat > /etc/resolv.conf.head << "EOF"
# OpenDNS servers
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

finish

#END
