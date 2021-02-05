#!/bin/bash

INST="xray"
PORT_1="18443"
#PORT_2="18821"
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


cleanup "${INST}-${PORT_1}"
docker run --detach \
           --name "${INST}-${PORT_1}"  \
           --restart always  \
	   --publish ${PORT_1}:${PORT_1} \
           --volume /etc/xray/"${INST}-${PORT_1}".json:/etc/xray/config.json \
	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".crt:/etc/ssl/xray/xray.crt \
	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".key:/etc/ssl/xray/xray.key \
	   teddysun/xray

#cleanup "${INST}-${PORT_2}"
#docker run --detach \
#           --name "${INST}-${PORT_2}"  \
#           --restart always  \
#	   --publish ${PORT_2}:${PORT_2} \
#           --volume /etc/xray/"${INST}-${PORT_2}".json:/etc/xray/config.json \
#	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".crt:/etc/ssl/xray/xray.crt \
#	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME}"/"${DM_NAME}".key:/etc/ssl/xray/xray.key \
#	   teddysun/xray

