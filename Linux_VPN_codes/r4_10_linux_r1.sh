

##### check r4_27_linux.sh




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
