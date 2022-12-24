# slow

# https://www.linuxfromscratch.org/blfs/view/stable-systemd/postlfs/p11-kit.html
wget https://github.com/p11-glue/p11-kit/releases/download/0.24.1/p11-kit-0.24.1.tar.xz   --no-check-certificate
begin p11-kit-0.24.1 tar.xz

sed '20,$ d' -i trust/trust-extract-compat
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF


# code from ipfire
./configure --prefix=/usr --with-trust-paths=/etc/pki/ca-trust/source

make -j8
make install
which trust


# code from BIFS
mkdir p11-build
cd    p11-build

meson --prefix=/usr       \
      --buildtype=release \
      -Dtrust_paths=/etc/pki/anchors

ninja


ninja install
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
#

ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
which trust

finish
