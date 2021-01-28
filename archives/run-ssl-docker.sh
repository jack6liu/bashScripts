#!/bin/bash

VER=${VER:=3.2.0}
if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}

cleanup "ssl-12111"
docker run -d \
           --name ssl-12111  \
           --network host    \
           --restart always  \
           --env-file /etc/ss-libev/env_12111 \
           jack6liu/ss-libev:${VER}

cleanup "ssl-12121"
#docker run -d \
#           --name ssl-12121  \
#           --network host    \
#           --restart always  \
#           --env-file /etc/ss-libev/env_12121 \
#           jack6liu/ss-libev:${VER}

cleanup "ssl-12311"
docker run -d \
           --name ssl-12311  \
           --network host    \
           --restart always  \
           --env-file /etc/ss-libev/env_12311 \
           jack6liu/ss-libev:${VER}

cleanup "ssl-12321"
#docker run -d \
#           --name ssl-12321  \
#           --network host    \
#           --restart always  \
#           --env-file /etc/ss-libev/env_12321 \
#           jack6liu/ss-libev:${VER}

cleanup "ssl-kcp-usp-12411"
#docker run -d \
#           --name ssl-kcp-usp-12411  \
#           --network host        \
#           --restart always      \
#           --env-file /etc/ss-libev/env_kcp_12411 \
#           jack6liu/ss-libev:kcp-usp-${VER}

cleanup "ssl-us-kcp-12421"
#docker run -d \
#           --name ssl-us-kcp-12421  \
#           --network host        \
#           --restart always      \
#           --env-file /etc/ss-libev/env_kcp_12421 \
#           jack6liu/ss-libev:us-kcp-${VER}


