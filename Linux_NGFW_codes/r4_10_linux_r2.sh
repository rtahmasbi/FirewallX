# I made some changes:
# cp -iv arch/arm64/boot/Image.gz /boot/vmlinuz-5.13.12-lfs-11.0

# 10.3. Linux-5.13.12
begin linux-5.13.12 tar.xz
ARCH=arm64 make mrproper
ARCH=arm64 make defconfig
# make menuconfig

make
make modules_install
cp -iv arch/arm64/boot/Image.gz /boot/vmlinuz-5.13.12-lfs-11.0
cp -iv System.map /boot/System.map-5.13.12
cp -iv .config /boot/config-5.13.12
install -d /usr/share/doc/linux-5.13.12
cp -r Documentation/* /usr/share/doc/linux-5.13.12
finish


# 10.3.2. Configuring Linux Module Load Order
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
# End /etc/modprobe.d/usb.conf
EOF




# in the root we will make these changes one by one:
The root is from ipfire

1- bcm2711*
2- vmlinuz-5.15.49-ipfire and System.map-5.15.49-ipfire
3- initramfs
4- uInit-5.15.49-ipfire (it is not used anywhere)



cd /boot
mv bcm2711-rpi-* orig_ipfire/
cp /sources/linux-5.13.12/arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b* .
# we got error, did not run

mv /media/temp1/vmlinuz-5.15.49-ipfire  ~/orig_ipfire/
mv /media/temp1/System.map-5.15.49-ipfire ~/orig_ipfire/
mv /media/temp1/config-5.15.49-ipfire ~/orig_ipfire/
cp -iv /media/temp3/sources/linux-5.13.12/arch/arm64/boot/Image.gz /media/temp1/vmlinuz-5.15.49-ipfire
cp -iv /media/temp3/sources/linux-5.13.12/System.map /media/temp1/System.map-5.15.49-ipfire
cp -iv /media/temp3/sources/linux-5.13.12/.config /media/temp1/config-5.15.49-ipfire


# return them
cd ~/orig_ipfire/
cp vmlinuz-5.15.49-ipfire /media/temp1/
cp System.map-5.15.49-ipfire /media/temp1/
cp bcm2711-rpi-4-b.dtb /media/temp1/
cp config-5.15.49-ipfire /media/temp1/


# info
(lfs chroot) root:/sources/linux-5.13.12# l arch/arm64/boot/dts/broadcom/
total 128K
-rw-r--r-- 1 root root  26K Sep 30 18:06 bcm2711-rpi-4-b.dtb
-rw-rw-r-- 1 root root   71 Aug 18  2021 bcm2711-rpi-4-b.dts
-rw-r--r-- 1 root root  14K Sep 30 18:06 bcm2837-rpi-3-a-plus.dtb
-rw-rw-r-- 1 root root   76 Aug 18  2021 bcm2837-rpi-3-a-plus.dts
-rw-r--r-- 1 root root  14K Sep 30 18:06 bcm2837-rpi-3-b.dtb
-rw-rw-r-- 1 root root   71 Aug 18  2021 bcm2837-rpi-3-b.dts
-rw-r--r-- 1 root root  15K Sep 30 18:06 bcm2837-rpi-3-b-plus.dtb
-rw-rw-r-- 1 root root   76 Aug 18  2021 bcm2837-rpi-3-b-plus.dts
-rw-r--r-- 1 root root  14K Sep 30 18:06 bcm2837-rpi-cm3-io3.dtb
-rw-rw-r-- 1 root root   75 Aug 18  2021 bcm2837-rpi-cm3-io3.dts
drwxrwxr-x 2 root root 4.0K Sep 30 18:06 bcm4908
-rw-rw-r-- 1 root root  288 Aug 18  2021 Makefile
drwxrwxr-x 2 root root 4.0K Sep 30 18:06 northstar2
drwxrwxr-x 2 root root 4.0K Sep 30 18:06 stingray


(lfs chroot) root:/sources/linux-5.13.12# l arch/arm64/boot/
total 43M
drwxrwxr-x 33 root root 4.0K Aug 18  2021 dts
-rw-r--r--  1 root root  32M Sep 30 19:36 Image
-rw-r--r--  1 root root  11M Sep 30 19:36 Image.gz
-rw-rw-r--  1 root root 1.6K Aug 18  2021 install.sh
-rw-rw-r--  1 root root 1.2K Aug 18  2021 Makefile
(lfs chroot) root:/sources/linux-5.13.12# l arch/arm64/boot/dts/


################################################################################

echo $LFS

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys


umount -v $LFS/usr
umount -v $LFS/home
umount -v /mnt/lfs/boot/efi
umount -v /mnt/lfs/boot
umount -v /mnt/lfs/


################################################################################
mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3

umount /dev/sda1
umount /dev/sda2
umount /dev/sda3




#
