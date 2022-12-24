# 10.4. Using GRUB to Set Up the Boot Process


################v###############################################################
# u-boot
https://hechao.li/2021/12/20/Boot-Raspberry-Pi-4-Using-uboot-and-Initramfs/
https://elinux.org/RPi_U-Boot


mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3

cd /media/temp3
git clone git://git.denx.de/u-boot.git
wget https://busybox.net/downloads/busybox-1.33.2.tar.bz2
mkdir raspberrypi
cd raspberrypi/
svn checkout https://github.com/raspberrypi/firmware/trunk/boot

umount /dev/sda1
umount /dev/sda2
umount /dev/sda3




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
mount /dev/sda2 /boot/efi


# 4. Bootloader
cd u-boot
make rpi_4_defconfig
make
cp u-boot.bin /boot


cp /raspberrypi/boot/{bootcode.bin,start4.elf} /boot/
cat << EOF > config.txt
enable_uart=1
arm_64bit=1
kernel=u-boot.bin
EOF

mv config.txt /boot/


#### todo
#sudo cp arch/arm64/boot/Image /mnt/boot
cp arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb /mnt/boot/


# 6. Root filesystem
## 6.1 Create Directories
mkdir /rootfs
cd /rootfs
mkdir {bin,dev,etc,home,lib64,proc,sbin,sys,tmp,usr,var}
mkdir usr/{bin,lib,sbin}
mkdir var/log
ln -s lib64 lib
sudo chown -R root:root *


# 6.2 Build and Install Busybox
cd /
tar xf busybox-1.33.2.tar.bz2
cd busybox-1.33.2/
make defconfig
sed -i 's%^CONFIG_PREFIX=.*$%CONFIG_PREFIX="/rootfs"%' .config
make
make install

## 6.3 Install required libraries

readelf -a /rootfs/bin/busybox | grep -E "(program interpreter)|(Shared library)"
mkdir /rootfs/lib
cp -L /lib/{ld-linux-aarch64.so.1,libm.so.6,libresolv.so.2,libc.so.6} /rootfs/lib64/

## 6.4 Create device nodes
cd /rootfs
mknod -m 666 dev/null c 1 3
mknod -m 600 dev/console c 5 1


# 7. Boot the Board
## 7.2 Option 2: Boot with a permanent rootfs directly


## 7.2.2 Change boot commands
cd /boot/
cat << EOF > boot_cmd.txt
fatload mmc 0:1 \${kernel_addr_r} vmlinuz-5.13.12-lfs-11.0
setenv bootargs "console=serial0,115200 console=tty1 root=/dev/mmcblk0p3 rw rootwait init=/bin/sh"
booti \${kernel_addr_r} - \${fdt_addr}
EOF

/u-boot/tools/mkimage -A arm64 -O linux -T script -C none -d boot_cmd.txt boot.scr


# 7.2.3 Boot it!
cd /
umount /dev/sda1
umount /dev/sda2
umount /dev/sda3

logout

echo $LFS

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys


umount -v $LFS/usr
umount -v $LFS/home
umount -v $LFS

umount /mnt/lfs


-- we just had rainbow screen
cp ~/temp1/bcm2711-rpi-4-b.dtb /media/temp1/

-- grub: /kernel.img did not found
mv /media/temp1/vmlinuz-5.13.12-lfs-11.0 Image
mv /media/temp1/System.map-5.13.12 System.map

NO




#
