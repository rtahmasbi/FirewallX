# u-boot
dd if=/dev/zero of=/boot/uboot.env bs=1K count=128
nano /config/u-boot/boot.cmd
cp -vf /config/u-boot/* /boot/
KVER=5.13.12
sed -e "s/xxxKVERxxx/$KVER/g" -i /boot/uEnv.txt
sed -e "s/xxxROOT-UUIDxxx/437408e9-9c3f-4951-ba61-81de70b19b28/g" -i /boot/uEnv.txt
cd /u-boot
make CROSS_COMPILE="" rpi_3_config
make CROSS_COMPILE="" tools
install -v -m 755 tools/mkimage /usr/bin
#************ I think we need to run boot.mk in config/u-boot/boot.mk after this step
cd /boot/
bash boot.mk
