# 10.4. Using GRUB to Set Up the Boot Process



###
cd ~
wget https://github.com/raspberrypi/rpi-firmware/archive/refs/heads/master.zip
unzip master.zip  -d /media/temp1/

cp -r ~/rpi-firmware-master/* /media/temp1/

cp -r ~/temp3/* /media/temp3/
rm -r /media/temp3/boot/*


umount /dev/sda1
umount /dev/sda2
umount /dev/sda3


###

export LFS=/mnt/lfs

mount /dev/sda3 /mnt/lfs

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/qemu-aarch64-static  \
    /bin/bash --login +h

#
#in the (lfs chroot) root:/# 
mount /dev/sda1 /boot
mkdir /boot/efi
mount /dev/sda2 /boot/efi


begin linux-5.13.12 tar.xz
ARCH=arm64 make mrproper
ARCH=arm64 make defconfig
make
make modules_install
cp -iv arch/arm64/boot/Image.gz /boot/vmlinuz-5.13.12-lfs-11.0
cp -iv System.map /boot/System.map-5.13.12
cp -iv .config /boot/config-5.13.12
finish

grub-install /dev/sda --target arm64-efi
(lfs chroot) root:/sources# grub-install /dev/sda --target arm64-efi
Installing for arm64-efi platform.
Installation finished. No error reported.

grub-install /dev/sda --target arm64-efi --removable

logout
# on root

echo $LFS

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys


umount -v $LFS/usr
umount -v $LFS/home


umount $LFS/boot/efi
umount $LFS/boot/
umount $LFS/



#
mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3



sda                                                                                  
├─sda1      vfat     FAT16       64C8-0C04                             284.3M    43% /media/temp1
├─sda2      vfat     FAT16       AF5A-8744                                 2G     0% /media/temp2
└─sda3      ext4     1.0         0124aaa8-0424-4499-8d57-88f64c3e4a16   16.3G    11% /media/temp3

nano /media/temp3/etc/fstab

# Begin /etc/fstab
# file system  mount-point  type     options             dump  fsck
#                                                              order
UUID=64C8-0C04                             /boot        vfat     defaults            0     1
UUID=AF5A-8744                             /boot/efi    vfat     defaults            0     1
UUID=0124aaa8-0424-4499-8d57-88f64c3e4a16  /            ext4     defaults    0     1
proc           /proc        proc     nosuid,noexec,nodev    0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0
# End /etc/fstab



cat > /media/temp1/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5
insmod part_msdos
insmod fat
set root=(hd0,msdos1)
menuentry "GNU/Linux, Linux 5.13.12-lfs-11.0" {
        echo    'Loading Linux ...'
        search --no-floppy --fs-uuid --set=root 64C8-0C04
        linux   /vmlinuz-5.13.12-lfs-11.0 root=UUID=0124aaa8-0424-4499-8d57-88f64c3e4a16 ro rootdelay=10 panic=10 
        echo    'Loading initial ramdisk ...'
        initrd  /initramfs-linux.img
}

EOF


umount /dev/sda1
umount /dev/sda2
umount /dev/sda3



# Camera sensor devices

https://www.raspberrypi.com/documentation/computers/raspberry-pi.html



cd ~
wget https://github.com/raspberrypi/rpi-firmware/archive/refs/heads/stable.zip
unzip stable.zip
cd /media/temp1/

rm b*
rm COPYING.linux
rm fi*
rm git_hash 
rm kernel*
rm LICENCE.broadcom 
rm Module*
rm -r modules/
rm NOTICE.md 
rm start*
rm uname_string*
rm -r vc/
rm README.md
rm -r overlays/



cp -r ~/rpi-firmware-stable/* /media/temp1/

umount /dev/sda1
umount /dev/sda2
umount /dev/sda3


dmesg | tail



#
