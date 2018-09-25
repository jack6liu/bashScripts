#!/bin/bash

INST="v2ray"
PORT_1="12611"
PORT_2="12621"
PORT_3="12631"
VER=${VER:=latest}
if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}

cleanup "${INST}-${PORT_1}"
docker run -d \
           --name "${INST}-${PORT_1}"  \
           --network host    \
           --restart always  \
           --volume /etc/v2ray/"${INST}-${PORT_1}"-config.json:/etc/v2ray/config.json \
           v2ray/official:${VER}


cleanup "${INST}-${PORT_2}"
docker run -d \
           --name "${INST}-${PORT_2}"  \
           --network host    \
           --restart always  \
           --volume /etc/v2ray/"${INST}-${PORT_2}"-config.json:/etc/v2ray/config.json \
           v2ray/official:${VER}


cleanup "${INST}-${PORT_3}"
docker run -d \
           --name "${INST}-${PORT_3}"  \
           --network host    \
           --restart always  \
           --volume /etc/v2ray/"${INST}-${PORT_3}"-config.json:/etc/v2ray/config.json \
           v2ray/official:${VER}
