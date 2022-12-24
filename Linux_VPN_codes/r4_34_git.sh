# https://www.linuxfromscratch.org/blfs/view/11.1/general/git.html
wget https://www.kernel.org/pub/software/scm/git/git-2.35.1.tar.xz

./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make

make html
make man

make perllibdir=/usr/lib/perl5/5.34/site_perl install
make install-man

make htmldir=/usr/share/doc/git-2.35.1 install-html


tar -xf ../git-manpages-2.35.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
