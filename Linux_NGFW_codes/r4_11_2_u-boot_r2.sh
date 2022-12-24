in chroot
cd /u-boot
mkdir -pv /usr/share/u-boot/rpi
make CROSS_COMPILE="" rpi_4_config
make CROSS_COMPILE=""
install -v -m 644 u-boot.bin /usr/share/u-boot/rpi/u-boot-rpi4.bin
install u-boot.bin /boot/u-boot-rpi4.bin
