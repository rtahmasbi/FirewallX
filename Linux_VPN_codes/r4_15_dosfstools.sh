# we had the vfat error
# so we sholud install dosfstools-4.2
# it is part of "Building an initramfs" of blfs

wget https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
Enable the following option in the kernel configuration and recompile the kernel:

File systems --->
  <DOS/FAT/EXFAT/NT Filesystems --->
    <*/M> MSDOS fs support             [CONFIG_MSDOS_FS]
    <*/M> VFAT (Windows-95) fs support [CONFIG_VFAT_FS]
#


begin dosfstools-4.2 tar.gz

./configure --prefix=/usr            \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.2

# --enable-compat-symlinks: This switch creates the dosfsck, dosfslabel, fsck.msdos, fsck.vfat, mkdosfs, mkfs.msdos, and mkfs.vfat symlinks required by some programs.

make
make install

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
