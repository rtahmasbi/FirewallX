cp /media/temp1/System.map-5.13.12 ~/temp1_rasool_linux_image
cp /media/temp1/vmlinuz-5.13.12-lfs-11.0 ~/temp1_rasool_linux_image/
cp /media/temp1/config-5.13.12 ~/temp1_rasool_linux_image/


mkfs.fat -F 16 /dev/sda1
mkfs.fat -F 16 /dev/sda2


all the dtb files are here (just unzip linux-5.13.12 tar.xz)
/sources/linux-5.13.12/arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dtb



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


mount /dev/sda1 /boot
alias l="ls -lh"



###

# 4. Bootloader
cd u-boot
make rpi_4_defconfig
make
cp u-boot.bin /boot


cp -r /raspberrypi/boot/overlays /boot/

cp /raspberrypi/boot/{bootcode.bin,start4.elf} /boot/
cd /boot/
cat << EOF > config.txt
enable_uart=1
arm_64bit=1
kernel=u-boot.bin
EOF



-- for usb??
dtoverlay=dwc2,dr_mode=host

#### todo
cp /sources/linux-5.13.12/arch/arm64/boot/dts/broadcom/bcm2711-rpi-4-b.dts /boot/


--in the lfs chroot:
cp /temp1_rasool_linux_image/vmlinuz-5.13.12-lfs-11.0 /boot/Image
cp /temp1_rasool_linux_image/System.map-5.13.12 /boot/System.map
cp /temp1_rasool_linux_image/config-5.13.12 /boot/config



## 7.2.2 Change boot commands
cd /boot/
cat << EOF > boot_cmd.txt
setenv fdtfile bcm2711-rpi-4-b.dtb
fatload mmc 0:1 \${kernel_addr_r} Image
fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}
setenv bootargs "console=serial0,115200 console=tty1 root=/dev/mmcblk0p3 rw rootwait init=/bin/sh"
booti \${kernel_addr_r} - \${fdt_addr}
EOF


cd /boot/
cat << EOF > boot_cmd.txt
setenv fdtfile bcm2711-rpi-4-b.dtb
setenv bootargs "console=serial0,115200 root=/dev/mmcblk0p3 rw rootwait init=/bin/sh"
fatload usb 0:1 \${kernel_addr_r} Image
fatload usb 0:1 ${fdt_addr_r} ${fdtfile}
booti \${kernel_addr_r} - \${fdt_addr}
EOF


cd /boot/
cat << EOF > boot_cmd.txt
fatload mmc 1:1 \${kernel_addr_r} Image
setenv bootargs "console=serial0,115200 console=tty1 root=/dev/mmcblk0p3 rw rootwait init=/bin/sh"
booti \${kernel_addr_r} - \${fdt_addr}
EOF


/u-boot/tools/mkimage -A arm64 -O linux -T script -C none -d boot_cmd.txt boot.scr


# 7.2.3 Boot it!
cd /
umount /dev/sda1

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




https://forums.raspberrypi.com/viewtopic.php?f=98&t=292632
USB is not enabled by default because having the PHY enabled but unused consumes power. To enable the DWC2 USB controller in host mode add the following property to config.txt.
Code: Select all

dtoverlay=dwc2,dr_mode=host


https://github.com/home-assistant/operating-system




https://www.youtube.com/watch?v=ni72NvaX7kU&ab_channel=InEcLabsEmbedded%26AutomotiveLinux
The boot sequence of the Raspberry Pi is basically this:
Stage 1 boot is in the on-chip ROM. Loads Stage 2 in the L2 cache
Stage 2 is bootcode.bin. Enables SDRAM and loads Stage 3
Stage 3 is loader.bin. It knows about the .elf format and loads start.elf
start.elf loads kernel.img. It then also reads config.txt, cmdline.txt and bcm2835.dtb If the dtb file exists, it is loaded at 0×100 & kernel @ 0×8000 If disable_commandline_tags is set it loads kernel @ 0×0 Otherwise it loads kernel @ 0×8000 and put ATAGS at 0×100
kernel.img is then run on the ARM.
Everything is run on the GPU until kernel.img is loaded on the ARM.




#
in the root:
cp ~/temp1/dtb-5.15.49-ipfire/broadcom/* /mnt/lfs/boot
cp ~/temp1/bootcode.bin /mnt/lfs/boot
cp ~/temp1/fixup* /mnt/lfs/boot
cp ~/temp1/start* /mnt/lfs/boot




#END
