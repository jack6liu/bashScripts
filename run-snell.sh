#!/bin/bash

INST="snell"
PORT="18861"
VER=${VER:=latest}
DM_NAME="ws0.go2see.xyz"

if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}


cleanup "${INST}-${PORT}"
docker run --detach \
           --name "${INST}-${PORT}"  \
           --restart always  \
	   --publish ${PORT}:30102 \
	   --publish ${PORT}:30102/udp \
	   --env PSK=1wDkCdo40ns8CUEx \
	   --env OBFS=tls \
	   --env OBFS_HOST=global.jd.com \
	   echoer/snell


