# make a backup

# You should not be using dd on mounted devices. unmount all the partitions first, then your command should work.

#https://askubuntu.com/questions/227924/sd-card-cloning-using-the-dd-command
#sudo dd if=/dev/mmcblk0 of=~/sd-card-copy.img bs=1M status=progress
mount /dev/sda1 /media/temp
umount /dev/sda1

dd if=/dev/sda of=~/rasool_aarch64.img bs=1M status=progress


31914459136 bytes (32 GB, 30 GiB) copied, 397 s, 80.4 MB/s 
30436+1 records in
30436+1 records out
31914983424 bytes (32 GB, 30 GiB) copied, 398.375 s, 80.1 MB/s
