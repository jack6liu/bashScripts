#!/bin/bash

HTTP_PORT="80"
HTTPS_PORT="443"

if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}

cleanup "naiveproxy"
docker run --detach \
           --name "naiveproxy"  \
           --publish ${HTTPS_PORT}:443 \
           --publish ${HTTP_PORT}:80 \
           --restart always  \
           --volume /etc/naiveproxy:/etc/naiveproxy \
           --volume /var/www/html:/var/www/html \
           --env PATH=/etc/naiveproxy/Caddyfile \
           pocat/naiveproxy

