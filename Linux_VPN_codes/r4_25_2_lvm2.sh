
# lvm2
# https://www.linuxfromscratch.org/blfs/view/11.1/postlfs/lvm2.html

# wget https://sourceware.org/ftp/lvm2/LVM2.2.03.13.tgz


# The LVM2 package is a set of tools that manage logical partitions. 
# It allows spanning of file systems across multiple physical disks and disk partitions and provides for dynamic growing or shrinking of logical partitions, mirroring and low storage footprint snapshots.

Device Drivers --->
  [*] Multiple devices driver support (RAID and LVM) ---> [CONFIG_MD]
    <*/M>   Device mapper support                         [CONFIG_BLK_DEV_DM]
    <*/M>   Crypt target support                          [CONFIG_DM_CRYPT]
    <*/M>   Snapshot target                               [CONFIG_DM_SNAPSHOT]
    <*/M>   Thin provisioning target                      [CONFIG_DM_THIN_PROVISIONING]
    <*/M>   Cache target (EXPERIMENTAL)                   [CONFIG_DM_CACHE]
    <*/M>   Mirror target                                 [CONFIG_DM_MIRROR]
    <*/M>   Zero target                                   [CONFIG_DM_ZERO]
    <*/M>   I/O delaying target                           [CONFIG_DM_DELAY]
  [*] Block devices --->
    <*/M>   RAM block device support                      [CONFIG_BLK_DEV_RAM]
Kernel hacking --->
  Generic Kernel Debugging Instruments --->
    [*] Magic SysRq key                                   [CONFIG_MAGIC_SYSRQ]
    
#
begin LVM2.2.03.13 tgz

PATH+=:/usr/sbin                \
./configure --prefix=/usr       \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  \
			--with-usrlibdir=/usr/lib \
			--with-udevdir=/lib/udev/rules.d \
			--with-default-locking-dir=/run/lvm \
			--enable-lvmetad \
			--enable-udev_rules

make -j8
make -C tools install_tools_dynamic
make -C udev  install
make -C libdm install
#make S=shell/thin-flags.sh check_local # no test
make install

which lvm
which fsadm

finish



#END
