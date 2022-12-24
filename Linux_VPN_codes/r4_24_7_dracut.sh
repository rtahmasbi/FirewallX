
# dracut
# wget https://source.ipfire.org/source-2.x/dracut-057.tar.gz

# Dracut is a set of tools that provide enhanced functionality for automating the Linux boot process. The tool named dracut is used to create a Linux boot image by copying tools and files from an installed system and combining it with the Dracut framework, which is usually found in /usr/lib/dracut/modules.d.


begin dracut-057 tar.gz
./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc
make -j8
make install sbindir=/sbin sysconfdir=/etc

#cp -vf $(DIR_SRC)/config/dracut/ipfire.conf \
#		/usr/lib/dracut/dracut.conf.d/ipfire.conf
mkdir -p /usr/lib/dracut/dracut.conf.d/
cat > /usr/lib/dracut/dracut.conf.d/ipfire.conf << "EOF"
# Load microcode for the CPU early
early_microcode="yes"

# Compress using Zstandard
compress="zstd"
EOF

which dracut

finish


OR 
# no need
057.zip
unzip 057.zip
cd dracut-057
./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc
make -j8
make install sbindir=/sbin sysconfdir=/etc


#cannot parse http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl
# we solve this error by above steps


-rwxr-xr-x 1 root root 96K Oct  2 00:30 /usr/bin/dracut
-rwxr-xr-x 1 root root 96K Oct  2 21:28 /usr/bin/dracut
