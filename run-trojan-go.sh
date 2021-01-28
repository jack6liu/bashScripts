#!/bin/bash

INST="trojan-go"
PORT="443"
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
docker run -d \
           --name "${INST}-${PORT}"  \
           --restart always  \
	   -p ${PORT}:${PORT} \
           --volume /etc/trojan-go/config.json:/etc/trojan-go/config.json \
	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".crt:/etc/ssl/trojan-go/trojan-go.crt \
	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".key:/etc/ssl/trojan-go/trojan-go.key \
	   teddysun/trojan-go

