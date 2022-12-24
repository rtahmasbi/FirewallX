

depmod -a 5.13.12

# Create initramfs images
# https://fedoraproject.org/wiki/Dracut
# https://man7.org/linux/man-pages/man8/dracut.8.html

# I changed:
#dracut --force --verbose --kver 5.13.12 --strip /boot/initramfs-5.13.12.img
dracut --force --kver 5.13.12 --kernel-only --strip /boot/initramfs-5.13.12.img

cd /boot
/u-boot/tools/mkimage -A arm64 -T ramdisk -C lzma -d initramfs-5.13.12.img uInit-5.13.12
# dont remove initramfs because grub need this to boot.


#################### no need

# dracut --list-modules --kver 5.13.12



# I had this error:
dracut: Cannot find module directory /lib/modules/5.15.0-48-generic/
uname -a
> Linux server1 5.15.0-48-generic #54-Ubuntu SMP Fri Aug 26 13:26:29 UTC 2022 aarch64 GNU/Linux

ls /lib/modules/
> 5.13.12  kernel  modules.order

We shoudl add --kver



l /lib/modules/5.13.12/kernel/fs/fat/
total 56K
-rw-r--r-- 1 root root  35K Oct  2 13:27 fat.ko.xz
-rw-r--r-- 1 root root 6.2K Oct  2 13:27 msdos.ko.xz
-rw-r--r-- 1 root root 8.2K Oct  2 13:27 vfat.ko.xz


ls -l /dev/disk/by-uuid/




dracut --force -L 6 --kver 5.13.12 --strip /boot/initramfs-5.13.12.img

dracut --force -L 6 --kver 5.13.12 --fstab initramfs-5.13.12.img

modinfo -k 5.13.12 vfat
# for 5.13.12: ls /lib/modules/

modinfo -k 5.13.12 bluetooth

modinfo -k 5.13.12 resume


# https://linuxhint.com/dracut-command-linux
dracut --print-cmdline

lvm
dracut --force -L 6 --kver 5.13.12 --fstab --modules lvm test.img

dracut --force -L 6 --kver 5.13.12 --kernel-only test.img




#END
