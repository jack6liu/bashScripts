#!/bin/bash
set -e

#
# get code to /opt, and keep there
#
mkdir -p /opt
cd /opt/

echo "... getting latest libsodium code ..."
curl -L -o libsodium.tgz https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar zxf libsodium.tgz

echo "... installing libsodium ..."
cd libsodium*
./configure

make && make install
echo "... everything is done ..."

