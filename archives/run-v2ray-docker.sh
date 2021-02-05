#!/bin/bash

INST="v2ray"
PORT_1="12611"
PORT_2="12621"
PORT_3="12631"
VER=${VER:=latest}
DM_NAME_1="h20.go2see.xyz"
DM_NAME_2="ws0.go2see.xyz"

CADDY_PORT="8443"

if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}


cleanup "${INST}-${PORT_3}"
#docker run -d \
##           --privileged  \
##           --name "${INST}-${PORT_3}"  \
##           --network host    \
##           --restart always  \
##           --volume /etc/v2ray/"${INST}-${PORT_3}"-config.json:/etc/v2ray/config.json \
##	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_2}"/"${DM_NAME_2}".crt:/etc/ssl/v2ray/v2ray.crt \
##	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_2}"/"${DM_NAME_2}".key:/etc/ssl/v2ray/v2ray.key \
##           jrohy/v2ray
	   #v2ray/official:${VER}
           #v2ray/dev:${VER}
           #v2ray/official:${VER}

cleanup "caddy-${CADDY_PORT}"
docker run --detach \
           --name "caddy-${CADDY_PORT}"  \
	   --publish ${CADDY_PORT}:443 \
	   --publish 8080:80 \
           --restart always  \
           --volume /etc/caddy/Caddyfile:/etc/Caddyfile \
           --volume /etc/ssl/caddy:/root/.caddy \
           abiosoft/caddy

cleanup "${INST}-${PORT_1}"
#docker run -d \
#           --privileged  \
#           --name "${INST}-${PORT_1}"  \
#           --network host    \
#           --restart always  \
#           --volume /etc/v2ray/"${INST}-${PORT_1}"-config.json:/etc/v2ray/config.json \
#	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_1}"/"${DM_NAME_1}".crt:/etc/ssl/v2ray/v2ray.crt \
#	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_1}"/"${DM_NAME_1}".key:/etc/ssl/v2ray/v2ray.key \
##           jrohy/v2ray
	   #v2ray/official:${VER}
           #v2ray/dev:${VER}
           #v2ray/official:${VER}


cleanup "${INST}-${PORT_2}"
#docker run -d \
##           --privileged  \
##           --name "${INST}-${PORT_2}"  \
##           --network host    \
##           --restart always  \
##           --volume /etc/v2ray/"${INST}-${PORT_2}"-config.json:/etc/v2ray/config.json \
##	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_2}"/"${DM_NAME_2}".crt:/etc/ssl/v2ray/v2ray.crt \
##	   --volume /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/"${DM_NAME_2}"/"${DM_NAME_2}".key:/etc/ssl/v2ray/v2ray.key \
##           jrohy/v2ray
	   #v2ray/official:${VER}
           #v2ray/dev:${VER}
           #v2ray/official:${VER}
