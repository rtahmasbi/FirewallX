# ca-certificates
# This step really solved the problem of `--no-check-certificate'.

# Error in wget : insecurely, use `--no-check-certificate'.



# We NEED ipfire `ca-certificates`, because of /etc/ssl/certs
mkdir ca-certificates
cd ca-certificates
#copy folder from https://github.com/ipfire/ipfire-2.x/tree/8c855a589271b52f9d2231fd520dc73fd66509fa/config/ca-certificates
wget https://raw.githubusercontent.com/ipfire/ipfire-2.x/8c855a589271b52f9d2231fd520dc73fd66509fa/config/ca-certificates/certdata.txt
wget https://raw.githubusercontent.com/ipfire/ipfire-2.x/master/config/ca-certificates/build.sh
wget https://github.com/ipfire/ipfire-2.x/blob/437fb4d72bd2814946d6bfc0425c36ae98b04284/config/ca-certificates/certdata2pem.py

bash ./build.sh
mkdir -pv /etc/ssl/certs
install -p -m 644 ca-bundle.crt ca-bundle.trust.crt /etc/ssl/certs
ln -svf certs/ca-bundle.crt /etc/ssl/cert.pem


######################
# still have the error --no-check-certificate
# we dont need this:
echo "check_certificate = off" >> ~/.wgetrc


######################
# --best
# https://www.linuxfromscratch.org/blfs/view/11.2/postlfs/make-ca.html
wget https://github.com/lfs-book/make-ca/releases/download/v1.10/make-ca-1.10.tar.xz
begin make-ca-1.10 tar.xz
make install
install -vdm755 /etc/ssl/local
which make-ca


/usr/sbin/make-ca -g
# ERROR: Extracting OpenSSL certificates to: No such file or directory
#/etc/ssl/certs.../usr/sbin/make-ca: line 943: /usr/bin/trust: 
#Failed!!!
# --> install p11-kit

wget http://www.cacert.org/certs/root.crt
wget http://www.cacert.org/certs/class3.crt
openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_1_root.pem

openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_3_root.pem

/usr/sbin/make-ca -r
