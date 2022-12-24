# 11.1. The End
echo 11.0 > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="11.0"
DISTRIB_CODENAME="Linux From Scratch by Rasool"
DISTRIB_DESCRIPTION="Linux From Scratch by Rasool"
EOF


cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="11.0"
ID=lfs
PRETTY_NAME="Linux From Scratch 11.0 by Rasool"
VERSION_CODENAME="Linux From Scratch by Rasool"
EOF
