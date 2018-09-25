#!/bin/bash
set -e

#
# get code to /opt, and keep there
#
RELEASE=${RELEASE:-v0.0.3}
if [[ -n "$1" ]]; then
    RELEASE=$1
fi

#curl -L -o simple-obfs-${VERSION}.tgz https://github.com/shadowsocks/simple-obfs/archive/v${VERSION}.tar.gz
#tar zxf simple-obfs-${VERSION}.tgz
#cd simple-obfs-${VERSION}
echo "... getting latest simple-obfs code ..."
rm -rf simple-obfs
git clone https://github.com/shadowsocks/simple-obfs.git
cd simple-obfs
git checkout tags/${RELEASE}

echo "... installing simple-obfs ..."
git submodule update --init --recursive
./autogen.sh
./configure
make && make install

echo "... everything is done ..."

