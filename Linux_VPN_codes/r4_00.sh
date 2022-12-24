
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/qemu-aarch64-static  \
    /bin/bash --login +h




package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2

	echo "[lfs-scripts] Starting build of $package_name at $(date)"

	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-scripts] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

cd /sources



alias l="ls -lh"
export MAKEFLAGS='-j6'



## if needed
in the root:

export LFS=/mnt/lfs

echo $LFS

mount /dev/sda3 /mnt/lfs

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run


mount /dev/sda1 /boot
mount /dev/sda2 /boot/efi



mount:
/dev/sda1 on /mnt/lfs type ext4 (rw,relatime)
udev on /mnt/lfs/dev type devtmpfs (rw,nosuid,relatime,size=32864520k,nr_inodes=8216130,mode=755,inode64)
devpts on /mnt/lfs/dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
proc on /mnt/lfs/proc type proc (rw,relatime)
sysfs on /mnt/lfs/sys type sysfs (rw,relatime)
tmpfs on /mnt/lfs/run type tmpfs (rw,relatime,inode64)



export LFS=/mnt/lfs

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
lsblk

umount -l /mnt/lfs/ 






mount /dev/sda1 /media/temp1
mount /dev/sda2 /media/temp2
mount /dev/sda3 /media/temp3
umount -l /mnt/lfs/ 



######################
cd rasool_sd_memory1
cp -rP /media/temp1 .
cp -rP /media/temp2 .
cp -rP /media/temp3 .

umount /dev/sda1
umount /dev/sda2
umount /dev/sda3





#END
