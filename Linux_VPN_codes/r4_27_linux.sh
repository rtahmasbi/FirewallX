
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



#
################################################################################
### method from ipFire

wget https://source.ipfire.org/source-2.x/arm-multi-patches-5.15-ipfire5.patch.xz

begin linux-5.13.12 tar.xz

# Apply Arm-multiarch kernel patches.
xzcat ../arm-multi-patches-5.15-ipfire5.patch.xz | patch -Np1


# Cleanup kernel source
#cp $(DIR_SRC)/config/kernel/kernel.config.$(BUILD_ARCH)-$(VERSUFIX) $(DIR_APP)/.config
#https://github.com/ipfire/ipfire-2.x/blob/master/config/kernel/kernel.config.aarch64-ipfire
cp ../kernel.config.aarch64-ipfire .config
make oldconfig
make clean


# Copy Module signing key configuration
#https://github.com/ipfire/ipfire-2.x/blob/master/config/kernel/x509.genkey
cp -f ../x509.genkey certs/x509.genkey


# Remove modules folder if exists
rm -rf /lib/modules/5.13.12/

# Build the kernel
#KERNEL_TARGET=Image
make -j8 Image modules




# Install the kernel
# KERNEL_TARGET=Image
# KERNEL_ARCH=arm64
# KERNEL_TARGET=
# BUILD_ARCH=aarch64
# HEADERS_ARCH = arm64
# KERNEL_ARCH  = arm64
# VER=5.13.12
# VERSUFIX=ipfire
cp -v arch/arm64/boot/Image /boot/vmlinuz-5.13.12
cp -v System.map /boot/System.map-5.13.12
cp -v .config /boot/config-5.13.12


make -j8 modules_install
# this coomand ads lots of *.ko files in /lib/modules/5.13.12/kernel


make -j8 dtbs
# thos command ads lotf of .dtb files in arch/arm64/boot/dts

mkdir -p /boot/dtb-5.13.12

for f in $(find arch/arm64/boot/dts/broadcom/ -name "*.dtb" ); do
    cp -v --parents $f /boot/dtb-5.13.12/
    chmod 644 /boot/dtb-5.13.12/$f
done
    
#cd $(DIR_APP)/arch/$(KERNEL_ARCH)/boot/dts && for f in $$(find -name "*.dtb"); do \
#            cp -v --parents $$f /boot/dtb-$(VER)-$(VERSUFIX)/ ; \
#            chmod 644 /boot/dtb-$(VER)-$(VERSUFIX)/$$f ; \
#        done

#


# Recreate source and build links
rm -rf /lib/modules/5.13.12/{build,source}
mkdir -p /lib/modules/5.13.12/build
ln -sf build /lib/modules/5.13.12/source

# Create dirs for extra modules
mkdir -p /lib/modules/5.13.12/extra

cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*") /lib/modules/5.13.12/build

cp Module.symvers System.map /lib/modules/5.13.12/build
rm -rf /lib/modules/5.13.12/build/{Documentation,scripts,include}

cp .config /lib/modules/5.13.12/build
cp -a scripts /lib/modules/5.13.12/build
find /lib/modules/5.13.12/build/scripts -name "*.o" -exec rm -vf {} \;

cp -a --parents arch/arm64/include /lib/modules/5.13.12/build
cp -a include /lib/modules/5.13.12/build/include

# Copy module signing key for off tree modules
cp -f certs/signing_key.* /lib/modules/5.13.12/build/certs/

# Install objtool
cp -a tools/objtool/objtool \
    /lib/modules/5.13.12/build/tools/objtool/ || :
cp -a --parents tools/build/{Build,Build.include,fixdep.c} \
    tools/scripts/utilities.mak /lib/modules/5.13.12/build

# Make sure we can build external modules
touch -r /lib/modules/5.13.12/build/Makefile \
    /lib/modules/5.13.12/build/include/generated/uapi/linux/version.h
touch -r /lib/modules/5.13.12/build/.config \
    /lib/modules/5.13.12/build/autoconf.h
cp /lib/modules/5.13.12/build/.config \
    /lib/modules/5.13.12/build/include/config/auto.conf

# Fix permissions
find /lib/modules/5.13.12 -name "modules.order" -exec chmod 644 {} \;

find /lib/modules/5.13.12 -name ".*.cmd" -exec rm -f {} \;


# Only do this once
install -m 755 usr/gen_init_cpio /sbin/

# disable drm by install drm to /bin/false because i915 ignore blacklisting
echo install drm /bin/false > /etc/modprobe.d/framebuffer.conf

# Blacklist old framebuffer modules
for f in $(find /lib/modules/5.13.12/kernel/drivers/video/fbdev/ -name *.ko.xz); do \
    echo "blacklist $(basename $f)" >> /etc/modprobe.d/framebuffer.conf ; \
done
# Blacklist new drm framebuffer modules
for f in $(find /lib/modules/5.13.12/kernel/drivers/gpu/drm -name *.ko.xz); do \
    echo "blacklist $(basename $f)" >> /etc/modprobe.d/framebuffer.conf ; \
done
sed -i -e "s|.ko.xz||g" /etc/modprobe.d/framebuffer.conf

# Disable ipv6 at runtime
echo "options ipv6 disable_ipv6=1" > /etc/modprobe.d/ipv6.conf
