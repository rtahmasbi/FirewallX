# nano
# wget https://www.nano-editor.org/dist/v5/nano-5.8.tar.xz

# tar xf nano-5.8.tar.xz
begin nano-5.8 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-5.8

make -j8
make install
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-5.8

finish


wget https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
wget https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v5.13.1.tar.xz
wget https://github.com/libfuse/libfuse/releases/download/fuse-3.10.4/fuse-3.10.4.tar.xz
wget http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz
wget https://sourceware.org/ftp/lvm2/LVM2.2.03.13.tgz
wget https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-4.1.tar.xz
wget https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2021.8.22.tgz
wget https://downloads.sourceforge.net/smartmontools/smartmontools-7.2.tar.gz
wget https://www.nano-editor.org/dist/v5/nano-5.8.tar.xz
