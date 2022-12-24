# mdadm
# wget https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-4.1.tar.xz
Device Drivers --->
  [*] Multiple devices driver support (RAID and LVM) ---> [CONFIG_MD]
    <*> RAID support                                      [CONFIG_BLK_DEV_MD]
    [*]   Autodetect RAID arrays during kernel boot       [CONFIG_MD_AUTODETECT]
    <*/M>  Linear (append) mode                           [CONFIG_MD_LINEAR]
    <*/M>  RAID-0 (striping) mode                         [CONFIG_MD_RAID0]
    <*/M>  RAID-1 (mirroring) mode                        [CONFIG_MD_RAID1]
    <*/M>  RAID-10 (mirrored striping) mode               [CONFIG_MD_RAID10]
    <*/M>  RAID-4/RAID-5/RAID-6 mode                      [CONFIG_MD_RAID456]
#

begin mdadm-4.1 tar.xz
sed 's@-Werror@@' -i Makefile
make
#./test --keep-going --logdir=test-logs --save-logs

make BINDIR=/usr/sbin install

which mdadm

finish
