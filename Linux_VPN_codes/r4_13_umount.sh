# under root
echo $LFS

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys


umount -v $LFS/usr
umount -v $LFS/home
umount -v $LFS


umount -v $LFS

umount /mnt/lfs/boot
umount /mnt/boot/efi
umount /mnt/lfs/boot/efi


# DONE!
