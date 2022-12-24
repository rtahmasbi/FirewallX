# WAS NOT possible, lots of errors to run `ct-ng build `


https://hechao.li/2021/12/20/Boot-Raspberry-Pi-4-Using-uboot-and-Initramfs/

sudo apt-get install gcc-aarch64-linux-gnu
sudo apt-get install g++-aarch64-linux-gnu

We shoudl not be in root!


apt-get install gperf bison flex texinfo
apt install libtool-bin
apt install help2man
apt install libncurses-dev


./bootstrap
./configure --prefix=${PWD}
make
make install
export PATH="${PWD}/bin:${PATH}"


ct-ng aarch64-unknown-linux-gnu

# https://github.com/crosstool-ng/crosstool-ng/issues/1625
sed -e 's|CT_ISL_MIRRORS=.*$|CT_ISL_MIRRORS="https://libisl.sourceforge.io"|' \
    -e 's|CT_EXPAT_MIRRORS=.*$|CT_EXPAT_MIRRORS="https://github.com/libexpat/libexpat/releases/download/R_2_2_6"|' \
    -i .config

ct-ng build
