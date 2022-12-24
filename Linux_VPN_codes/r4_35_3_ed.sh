# https://www.linuxfromscratch.org/blfs/view/svn/postlfs/ed.html
# https://ftp.gnu.org/gnu/ed/
# Ed is a line-oriented text editor. It is used to create, display, modify and otherwise manipulate text files, both interactively and via shell scripts.
cd /sources

wget https://ftp.gnu.org/gnu/ed/ed-1.18.tar.lz

tar --lzip -xvf ed-1.18.tar.lz

cd ed-1.18
./configure --prefix=/usr
make

make install

which ed
which red

cd /sources
rm -rf ed-1.18


#END
