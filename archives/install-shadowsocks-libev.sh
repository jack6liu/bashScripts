#!/bin/bash
set -e

#
# get code to /opt, and keep there
#
RELEASE=${RELEASE:-3.0.8}
if [[ -n "$1" ]]; then
    RELEASE=$1
fi

pkgSrcUrl="https://github.com/shadowsocks/shadowsocks-libev/releases/download/v${RELEASE}/shadowsocks-libev-${RELEASE}.tar.gz";

echo "... checking shadowsocks-libev release version \"${RELEASE}\" ..."
isValid=$(curl -k -s -I ${pkgSrcUrl} | head -n 1 | awk '{print $2}')
if [[ "$isValid" -eq 404 ]]; then
    echo "    \"${RELEASE}\" is not a valid version for shadowsocks-libev ..."
    exit 1
fi

echo "... downloading shadowsocks-libev release version \"${RELEASE}\" ..."
curl -k -L -o shadowsocks-libev-${RELEASE}.tgz ${pkgSrcUrl}

echo "... installing shadowsocks-libev release version \"${RELEASE}\" ..."
tar zxf shadowsocks-libev-${RELEASE}.tgz
cd shadowsocks-libev-${RELEASE}

./configure
make && make install
echo "... everything is done ..."


