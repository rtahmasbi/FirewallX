# 10.4. Using GRUB to Set Up the Boot Process

# I have error after grub-install /dev/sda:
#grub-install /dev/sda
#Installing for arm64-efi platform.
#/usr/sbin/grub-install: error: cannot find EFI directory.

# https://unix.stackexchange.com/questions/405472/cannot-find-efi-directory-issue-with-grub-install
#grub-install --efi-directory=/boot/EFI
#Installing for arm64-efi platform.
#/usr/sbin/grub-install: error: failed to get canonical path of `/boot/EFI'.



# I comented this command because /usr/lib/grub/arm64-efi/ exists: 
# grub-install /dev/sda --target arm64-efi
#Installing for arm64-efi platform.
#/usr/sbin/grub-install: error: cannot find EFI directory.

#grub-install /dev/sda --boot-directory=/boot --efi-directory=/boot/efi


# dd if=/dev/sda bs=4096 skip=0 count=1 status=none | hexdump -C
#000001b0  00 00 00 00 00 00 00 00  2b e1 df 0d 00 00 00 00  |........+.......|
#000001c0  01 01 83 1f a0 e4 00 08  00 00 00 1c b7 03 00 00  |................|


# on the root
#root@server1:/home/ras# grub-install /dev/sda
#Installing for x86_64-efi platform.
#Installation finished. No error reported.

IMPORTANT:
grub-install  will make /media/temp2/EFI/*

--best
# on the root
root@server1:/home/ras# grub-install /dev/sda --directory /mnt/lfs/usr/lib/grub/arm64-efi/
#Installing for arm64-efi platform.
#Installation finished. No error reported.


grub-install /dev/sda --target arm64-efi --directory /mnt/lfs/usr/lib/grub/arm64-efi/


cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5
insmod ext2
set root=(hd0,1)
menuentry "GNU/Linux, Linux 5.13.12-lfs-11.0" {
        linux   /boot/vmlinuz-5.13.12-lfs-11.0 root=/dev/sda1 ro rootdelay=10
}
EOF



########

another try with a new Flash memory

https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4
-- first format

cfdisk /dev/sda
parted -l

fdisk /dev/sda
Type o. This will clear out any partitions on the drive.
Type p to list partitions. There should be no partitions left.
Type n, then p for primary, 1 for the first partition on the drive, press ENTER to accept the default first sector, then type +500M for the last sector.
Type t, then c to set the first partition to type W95 FAT32 (LBA).
Type a for bootable
Type n, then p for primary, 2, +2G
Type t, then ef EFI (FAT-12/16/32)
Type n, then p for primary, 3, +20G
Write the partition table and exit by typing w.

mkfs.fat -F 16 /dev/sda1
mkfs.fat -F 16 /dev/sda2
mkfs.ext4 /dev/sda3

#mkfs.vfat /dev/sda1
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

cfdisk /dev/sda  then type: EFI (FAT-12/16/32) (ef)

#mkdir -pv /mnt/rescue
#mount -v -t vfat /dev/sda1 /mnt/rescue

mkdir -pv /mnt/boot/efi
mount -v -t vfat /dev/sda1 /mnt/boot/efi
mount /dev/sdb1 /mnt/lfs

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run



grub-install --target=arm64-efi --removable --efi-directory=/mnt/rescue --boot-directory=/mnt/rescue

umount /mnt/rescue

mount /dev/sda1 /mnt/boot/efi


# in the (lfs chroot) root:/#:
mkdir -pv /boot/efi

mount -v -t vfat /dev/sda1 /boot/efi



#in the root:
cd /mnt/lfs/sources
wget https://github.com/rhboot/efibootmgr/archive/18/efibootmgr-18.tar.gz
wget https://github.com/rhboot/efivar/releases/download/38/efivar-38.tar.bz2
wget http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz
wget https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz


# in the (lfs chroot) root:/#:
begin mandoc-1.14.6 tar.gz 
./configure
make mandoc
install -vm755 mandoc   /usr/bin
install -vm644 mandoc.1 /usr/share/man/man1
finish


begin efivar-38 tar.bz2
sed '/prep :/a\\ttouch prep' -i src/Makefile
sed '/sys\/mount\.h/d' -i src/util.h
sed '/unistd\.h/a#include <sys/mount.h>' -i src/gpt.c src/linux.c
make
make install LIBDIR=/usr/lib
finish


begin popt-1.18 tar.gz
./configure --prefix=/usr --disable-static
make
sed -i 's@\./@src/@' Doxyfile
#doxygen
make install
install -v -m755 -d /usr/share/doc/popt-1.18
#install -v -m644 doxygen/html/* /usr/share/doc/popt-1.18
finish


# in the (lfs chroot) root:/#:
begin efibootmgr-18 tar.gz
make EFIDIR=/boot/efi/
make install EFIDIR=/boot/efi/
finish

grub-install --target=arm64-efi



################################################################################
################################################################################
################################################################################
#in the root
https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4



mount /dev/sda1 /mnt/boot/
cd ~
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz
mkdir rasool_u
bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C rasool_u

nano /mnt/boot/cmdline.txt
I chabged:
root=/dev/mmcblk0p2 rw rootwait console=serial0,115200 console=tty1 selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 kgdboc=serial0,115200
to:
root=/dev/sda1 rw rootwait console=serial0,115200 console=tty1 selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 kgdboc=serial0,115200


cp -r rasool_u/boot/* /mnt/boot/

umount /dev/sda1


################################################################################
# continue
mount /dev/sda1 /mnt/boot/
cd ~
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
mkdir rasool_aarch64
bsdtar -xpf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C rasool_aarch64

cp -r rasool_aarch64/boot/* /mnt/boot/
umount /dev/sda1


################################################################################
################################################################################
################################################################################
root@server1:~# lsblk -f
NAME        FSTYPE   FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                  
├─sda1      vfat     FAT32       AC3E-2F5C                                           
└─sda2      ext4     1.0         6aea4281-9bf1-444b-bc52-72e5f4d42108                
sdc                                                                                  
└─sdc1      ext4     1.0         4fa84a27-65a5-4759-9b64-4f08acbdd11f   25.4G     8% /media/temp
nvme0n1                                                                              
├─nvme0n1p1 vfat     FAT32       0EE9-E552                             504.6M     1% /boot/efi
└─nvme0n1p2 ext4     1.0         a3dd1a4f-afd2-4e45-98fb-acd92ec7d3e2  816.3G     8% /


## this is Scandisk micro
sda                                                                                  
├─sda1      vfat     FAT32       BE2C-B1EA                                           
└─sda2      ext4     1.0         ac435474-4ede-41ca-ad65-912ee80143cf                


# scandisk 64G new USB
sda                                                                                  
├─sda1      vfat     FAT32       C27E-1A92                                           
└─sda2      ext4     1.0         9d9972fc-911d-453e-b39c-dabe7dd40025                



#
https://wiki.archlinux.org/title/GRUB
https://wiki.archlinux.org/title/Arch_boot_process
https://linuxcommandlibrary.com/man/grub-install
--target=TARGET: install GRUB for TARGET platform [default=x86_64-efi]; available targets: arm-coreboot, arm-efi, arm-uboot, arm64-efi, i386-coreboot, i386-efi, i386-ieee1275, i386-multiboot, i386-pc, i386-qemu, i386-xen, i386-xen_pvh, ia64-efi, mips-arc, mips-qemu_mips, mipsel-arc, mipsel-loongson, mipsel-qemu_mips, powerpc-ieee1275, riscv32-efi, riscv64-efi, sparc64-ieee1275, x86_64-efi, x86_64-xen


For the new usb scan disk:
Partition Table: msdos

------------------
/media/temp2/boot/: is the main flash

sda           8:0    1  57.3G  0 disk 
├─sda1        8:1    1   500M  0 part /media/temp
└─sda2        8:2    1    20G  0 part 
sdc           8:32   1  29.7G  0 disk 
└─sdc1        8:33   1  29.7G  0 part /media/temp2


- If for some reason it is necessary to run grub-install from outside of the installed system, append the --boot-directory= option with the path to the mounted /boot directory, e.g --boot-directory=/mnt/boot.
- If you use the option --removable then GRUB will be installed to esp/EFI/BOOT/BOOTX64.EFI

grub-install /dev/sda --target=arm64-efi --efi-directory=/media/temp --removable --boot-directory=/media/temp2/boot/ --directory=/media/temp2/usr/lib/grub/arm64-efi/

root@server1:
Installing for arm64-efi platform.
Installation finished. No error reported.

root@server1:/media/temp# tree /media/temp/
/media/temp/
└── EFI
    └── BOOT
        └── BOOTAA64.EFI

--> it isntalled BOOTAA64.EFI into above dir.

nano /media/temp2/etc/fstab 
C27E-1A92


################################################################################
################################################################################
################################################################################
# another Try

mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2

umount /dev/sda1
umount /dev/sda2


cfdisk /dev/sda
parted -l

fdisk /dev/sda
Disklabel type: dos


-- for the new usb 64G, I should change mydos to GPT:
parted /dev/sda mklabel gpt


after fdisk /dev/sda, I used "g" not "o"
sda                                                                                  
├─sda1      vfat     FAT32       EA3E-BE2B                                           
└─sda2      ext4     1.0         8b69830d-0d34-4df4-a9c7-537cd8b76af6                

mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sdc1 /media/temp3

grub-install /dev/sda --target=arm64-efi --efi-directory=/media/temp1 --removable --boot-directory=/media/temp3/boot/ --directory=/media/temp3/usr/lib/grub/arm64-efi/

root@server1:
Installing for arm64-efi platform.
Installation finished. No error reported.


nano /media/temp3/etc/fstab 
EA3E-BE2B


tree /media/temp1/
/media/temp1/
└── EFI
    └── BOOT
        └── BOOTAA64.EFI


umount /dev/sda1
umount /dev/sda2
umount /dev/sdc1



cfdisk /dev/sda
Type shoudl be "EFI System (C12A7328-F81F-11D2-BA4B-00A0C93EC93B)"
C12A7328-F81F-11D2-BA4B-00A0C93EC93B
C12A7328-F81F-11D2-BA4B-00A0C93EC93B


dd if=/dev/sda bs=4096 skip=0 count=1 status=none | hexdump -C
root@server1:/media# dd if=/dev/sda bs=4096 skip=0 count=1 status=none | hexdump -C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001c0  02 00 ee ff ff ff 01 00  00 00 ff 8f 29 07 00 00  |............)...|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI PART....\...|
00000210  e3 47 09 6c 00 00 00 00  01 00 00 00 00 00 00 00  |.G.l............|
00000220  ff 8f 29 07 00 00 00 00  00 08 00 00 00 00 00 00  |..).............|
00000230  de 8f 29 07 00 00 00 00  ce d4 23 02 b8 57 48 2f  |..).......#..WH/|
00000240  9f cb c7 6d 0c ed af 5e  02 00 00 00 00 00 00 00  |...m...^........|
00000250  80 00 00 00 80 00 00 00  72 cf 98 e3 00 00 00 00  |........r.......|
00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*



################################################################################
################################################################################
################################################################################
# check iPFire
mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3


cat /media/temp3/etc/fstab 
UUID=B0B7-3177 /boot    auto defaults,nodev,noexec,nosuid 1 2
UUID=B0B7-4179 /boot/efi auto defaults   1 2
UUID=437408e9-9c3f-4951-ba61-81de70b19b28 /        auto defaults   1 1

sda                                                                                  
├─sda1      vfat     FAT16       B0B7-3177                               9.4M    92% /media/temp1
├─sda2      vfat     FAT16       B0B7-4179                              31.8M     0% /media/temp2
└─sda3      ext4     1.0         437408e9-9c3f-4951-ba61-81de70b19b28    1.7G    44% /media/temp3


root@server1:/media# parted -l
Model: UFD 2.0 Silicon-Power4G (scsi)
Disk /dev/sda: 3882MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      16.8MB  134MB   117MB   primary  fat16        boot, lba
 2      134MB   168MB   33.6MB  primary  fat16        esp
 3      168MB   3882MB  3714MB  primary  ext2



l temp1/
total 85M
-rwxr-xr-x  1 root root  49K Oct 13  2021 bcm2711-rpi-400.dtb*
-rwxr-xr-x  1 root root  49K Oct 13  2021 bcm2711-rpi-4-b.dtb*
-rwxr-xr-x  1 root root  50K Oct 13  2021 bcm2711-rpi-cm4.dtb*
-rwxr-xr-x  1 root root 2.4K Jul  7 14:56 boot.cmd*
-rwxr-xr-x  1 root root  52K Nov 18  2021 bootcode.bin*
-rwxr-xr-x  1 root root   67 Jul  7 14:56 boot.mk*
-rwxr-xr-x  1 root root 2.5K Jul  7 14:56 boot.scr*
-rwxr-xr-x  1 root root 202K Jul  7 13:39 config-5.15.49-ipfire*
-rwxr-xr-x  1 root root 1.9K Jul  7 13:31 config.txt*
drwxr-xr-x 10 root root 2.0K Jul  7 13:40 dtb-5.15.49-ipfire/
drwxr-xr-x  2 root root 2.0K Jul  7 15:15 efi/
-rwxr-xr-x  1 root root 3.2K Nov 18  2021 fixup4cd.dat*
-rwxr-xr-x  1 root root 5.3K Nov 18  2021 fixup4.dat*
-rwxr-xr-x  1 root root 8.3K Nov 18  2021 fixup4db.dat*
-rwxr-xr-x  1 root root 8.3K Nov 18  2021 fixup4x.dat*
-rwxr-xr-x  1 root root 3.2K Nov 18  2021 fixup_cd.dat*
-rwxr-xr-x  1 root root 7.2K Nov 18  2021 fixup.dat*
-rwxr-xr-x  1 root root  11K Nov 18  2021 fixup_db.dat*
-rwxr-xr-x  1 root root  11K Nov 18  2021 fixup_x.dat*
drwxr-xr-x  5 root root 2.0K Dec 31  1979 grub/
-rwxr-xr-x  1 root root  15M Jul  7 13:41 initramfs-5.15.49-ipfire.img*
-rwxr-xr-x  1 root root 783K Nov 18  2021 start4cd.elf*
-rwxr-xr-x  1 root root 3.6M Nov 18  2021 start4db.elf*
-rwxr-xr-x  1 root root 2.2M Nov 18  2021 start4.elf*
-rwxr-xr-x  1 root root 2.9M Nov 18  2021 start4x.elf*
-rwxr-xr-x  1 root root 783K Nov 18  2021 start_cd.elf*
-rwxr-xr-x  1 root root 4.6M Nov 18  2021 start_db.elf*
-rwxr-xr-x  1 root root 2.9M Nov 18  2021 start.elf*
-rwxr-xr-x  1 root root 3.6M Nov 18  2021 start_x.elf*
-rwxr-xr-x  1 root root 4.9M Jul  7 13:39 System.map-5.15.49-ipfire*
-rwxr-xr-x  1 root root 128K Jul  7 14:56 uboot.env*
-rwxr-xr-x  1 root root 544K Jul  7 14:55 u-boot-rpi3.bin*
-rwxr-xr-x  1 root root 590K Jul  7 14:55 u-boot-rpi4.bin*
-rwxr-xr-x  1 root root  114 Jul  7 15:15 uEnv.txt*
-rwxr-xr-x  1 root root  15M Jul  7 13:41 uInit-5.15.49-ipfire*
-rwxr-xr-x  1 root root  27M Jul  7 13:39 vmlinuz-5.15.49-ipfire*

tree /media/temp2/
temp2/
└── EFI
    └── BOOT
        └── BOOTAA64.EFI

#
l /media/temp3/
total 88K
drwxr-xr-x  2 root root 4.0K Jul  7 15:13 bin/
drwxr-xr-x  2 root root 4.0K Jul  7 15:15 boot/
drwxr-xr-x  2 root root 4.0K Jul  7 15:13 dev/
drwxr-xr-x 49 root root 4.0K Aug 30 20:13 etc/
drwxr-xr-x  3 root root 4.0K Jul  7 15:13 home/
drwxr-xr-x  8 root root 4.0K Jul  7 15:13 lib/
lrwxrwxrwx  1 root root    3 Jul  7 13:00 lib64 -> lib/
drwx------  2 root root  16K Jul  7 15:15 lost+found/
drwxr-xr-x  5 root root 4.0K Jul  7 15:13 media/
drwxr-xr-x  2 root root 4.0K Jul  7 13:00 mnt/
drwxr-xr-x  3 root root 4.0K Jul  7 15:13 opt/
drwxr-xr-x  2 root root 4.0K Jul  7 15:15 proc/
drwxr-xr-x  4 root root 4.0K Aug 29 18:44 root/
drwxr-xr-x 13 root root 4.0K Jul  7 15:06 run/
drwxr-xr-x  2 root root 4.0K Jul  7 15:13 sbin/
drwxr-xr-x  3 root root 4.0K Jul  7 15:13 srv/
drwxr-xr-x  2 root root 4.0K Jul  7 15:13 sys/
drwxrwxrwt  2 root root 4.0K Aug 30 20:13 tmp/
drwxr-xr-x 10 root root 4.0K Jul  7 15:23 usr/
drwxr-xr-x 15 root root 4.0K Jul  7 15:13 var/



l /media/temp3/boot/
total 0

# IMPORTANT
the files in temp1 are from:
https://github.com/raspberrypi/rpi-firmware

## lets copy files from ipFire to a new flash
cp -r /media/temp1/ ~
cp -r /media/temp2/ ~


umount /dev/sda1
umount /dev/sda2
umount /dev/sda3




fdisk /dev/sda
Type o. This will clear out any partitions on the drive.
Type p to list partitions. There should be no partitions left.
Type n, then p for primary, 1 for the first partition on the drive, press ENTER to accept the default first sector, then type +500M for the last sector.
Type t, then c to set the first partition to type W95 FAT32 (LBA).
Type a for bootable
Type n, then p for primary, 2 for the second partition on the drive, and then press ENTER twice to accept the default first and last sector.
Write the partition table and exit by typing w.

#mkfs.vfat /dev/sda1
mkfs.fat -F 16 /dev/sda1
mkfs.fat -F 16 /dev/sda2
mkfs.ext4 /dev/sda3

#mkfs -v -t ext2 /dev/sda1
#mkfs -v -t ext2 /dev/sda2

mkfs -t fat -F 16 /dev/sda1
mkfs.fat  -F 16 /dev/sda1

cfdisk /dev/sda


cfdisk /dev/sda  then type: EFI (FAT-12/16/32) (ef)

root@server1:~# parted -l
Model:  USB  SanDisk 3.2Gen1 (scsi)
Disk /dev/sda: 61.5GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  525MB   524MB   primary  fat16        boot, lba
 2      525MB   2673MB  2147MB  primary  fat32        esp
 3      2673MB  24.1GB  21.5GB  primary  ext4


#
mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2

sda                                                                                  
├─sda1      vfat     FAT16       15ED-0399                             499.7M     0% /media/temp1
├─sda2      vfat     FAT32       15ED-9B0A                                 2G     0% /media/temp2
└─sda3      ext4     1.0         3287cdc9-1a2f-4d1a-81da-2edf4a3e69e0                

cp -r ~/temp1/* /media/temp1/
cp -r ~/temp2/* /media/temp2/

cp -r /media/temp/ ~
mv ~/temp ~/temp3    # --> ~/temp3 is rasool_arch64

cp -r ~/temp2/* /media/temp2/

mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3

cp -r ~/temp3/* /media/temp3/




umount /dev/sda1
umount /dev/sda2
umount /dev/sda3


#For the USB 64G
sda                                                                                  
├─sda1      vfat     FAT16       1276-5D97                                           
├─sda2      vfat     FAT16       3A4F-2247                                           
└─sda3      ext4     1.0         7edf466a-cace-4fbc-855e-6f9a36e8f806                


Partition Table: msdos
Disk Flags: 
Number  Start   End     Size    Type     File system  Flags
 1      1049kB  525MB   524MB   primary  fat16        boot, lba
 2      525MB   2673MB  2147MB  primary  fat16        esp
 3      2673MB  24.1GB  21.5GB  primary  ext4

#

mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3

cp -r ~/temp1/* /media/temp1/
cp -r ~/temp2/* /media/temp2/
cp -r ~/temp3/* /media/temp3/
rm -r /media/temp3/boot/*


umount /dev/sda1
umount /dev/sda2
umount /dev/sda3


nano /media/temp1/grub/grub.cfg 
removed the sub menu



nano /media/temp3/etc/fstab

UUID=1276-5D97 /boot                        auto defaults,nodev,noexec,nosuid 1 2
UUID=3A4F-2247 /boot/efi                    auto defaults   1 2
UUID=7edf466a-cace-4fbc-855e-6f9a36e8f806 / ext4 defaults   1 1



root@server1:/media# parted -l
Model:  USB  SanDisk 3.2Gen1 (scsi)
Disk /dev/sda: 61.5GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  525MB   524MB   primary  ext2         boot, lba
 2      525MB   2673MB  2147MB  primary  ext2         esp
 3      2673MB  24.1GB  21.5GB  primary  ext4


#
sda                                                                                  
├─sda1      ext2     1.0         4f99aa4b-72d9-49ee-bb41-ac3582f8cf07                
├─sda2      ext2     1.0         f29f149f-1cd9-40eb-b937-4e5217e38c8e                
└─sda3      ext4     1.0         7edf466a-cace-4fbc-855e-6f9a36e8f806                


sda                                                                                  
├─sda1      vfat     FAT16       9586-902C                             499.7M     0% /media/temp1
├─sda2      vfat     FAT16       9587-0E55                                 2G     0% /media/temp2
└─sda3      ext4     1.0         7edf466a-cace-4fbc-855e-6f9a36e8f806   16.2G    12% /media/temp3


root@server1:~/temp1/grub/arm64-efi# cp fat.mod  vfat.mod 

cp /media/temp1/grub/arm64-efi/fat.mod /media/temp1/grub/arm64-efi/vfat.mod


cd ~
cp -r ~/rasool_aarch64/boot/* temp1_rasool_aarch64/
cp -r /media/temp1/efi temp1_rasool_aarch64/
cp -r /media/temp1/grub temp1_rasool_aarch64/
cd temp1_rasool_aarch64
#mv Image.gz vmlinuz-5.13.12-lfs-11.0
mount /dev/sda1 /mnt/lfs
cp /mnt/lfs/boot/config-5.13.12 ~/temp1_rasool_aarch64/
cp /mnt/lfs/boot/System.map-5.13.12 ~/temp1_rasool_aarch64/
cp /mnt/lfs/boot/vmlinuz-5.13.12-lfs-11.0 ~/temp1_rasool_aarch64/
umount /mnt/lfs

rm -r /media/temp1/*
cp -r ~/temp1_rasool_aarch64/* /media/temp1/

initrd	/initramfs-linux.img




lsblk -dno UUID /dev/sda1
blkid -s UUID -o value /dev/sda1



################################################################################
# try installing linux again

## if needed
in the root:
export LFS=/mnt/lfs

mount /dev/sda1 /mnt/lfs

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run



mount:
/dev/sda1 on /mnt/lfs type ext4 (rw,relatime)
udev on /mnt/lfs/dev type devtmpfs (rw,nosuid,relatime,size=32864520k,nr_inodes=8216130,mode=755,inode64)
devpts on /mnt/lfs/dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
proc on /mnt/lfs/proc type proc (rw,relatime)
sysfs on /mnt/lfs/sys type sysfs (rw,relatime)
tmpfs on /mnt/lfs/run type tmpfs (rw,relatime,inode64)



(lfs chroot) root:/sources# l /boot/
total 18M
-rw-r--r-- 1 root root 242K Sep 15 22:40 config-5.13.12
drwxr-xr-x 2 root root 4.0K Sep 16 22:07 efi
drwxr-xr-x 5 root root 4.0K Sep 16 22:08 grub
-rw-r--r-- 1 root root 6.3M Sep 15 22:40 System.map-5.13.12
-rw-r--r-- 1 root root  11M Sep 15 22:40 vmlinuz-5.13.12-lfs-11.0


on root:
(from my original lfs)
cp /mnt/lfs/boot/config-5.13.12 ~/temp1_rasool_aarch64/
cp /mnt/lfs/boot/System.map-5.13.12 ~/temp1_rasool_aarch64/
cp /mnt/lfs/boot/vmlinuz-5.13.12-lfs-11.0 ~/temp1_rasool_aarch64/

mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3

###
run 4_10.sh
###

cp ~/temp1/uEnv.txt  ~/temp1_rasool_aarch64/
cp -r ~/temp1_rasool_aarch64/* /media/temp1/

umount /dev/sda1
umount /dev/sda2
umount /dev/sda3


sda                                                                                  
├─sda1      vfat     FAT16       EEB3-267B                                           
├─sda2      vfat     FAT16       9587-0E55                                           
└─sda3      ext4     1.0         7edf466a-cace-4fbc-855e-6f9a36e8f806                



~/temp1_rasool_aarch64/grub/grub.cfg

cp ~/temp1/uEnv.txt 

cp -r ~/temp1/* /media/temp1/



################################################################################
#lets compile Linux on the final usb flash (with 3 partions)

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


begin linux-5.13.12 tar.xz
ARCH=arm64 make mrproper
ARCH=arm64 make defconfig
make
make modules_install
cp -iv arch/arm64/boot/Image.gz /boot/vmlinuz-5.13.12-lfs-11.0
cp -iv System.map /boot/System.map-5.13.12
cp -iv .config /boot/config-5.13.12
finish


# i did both with and without --removable
grub-install /dev/sda --target arm64-efi
(lfs chroot) root:/# grub-install /dev/sda --target arm64-efi
Installing for arm64-efi platform.
Installation finished. No error reported.

grub-install /dev/sda --target arm64-efi --removable
(lfs chroot) root:/# grub-install /dev/sda --target arm64-efi --removable
Installing for arm64-efi platform.
Installation finished. No error reported.




find / -mmin -60 -not -path "/proc/*" -not -path "/sys/*" # modification time


fsck.cramfs /dev/sda3



Disk identifier: 0x2b5c8d7e


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


#
