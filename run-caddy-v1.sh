#!/bin/bash

HTTP_PORT="8080"
HTTPS_PORT="8443"

if [[ $# = 1 ]]; then
    VER=$1
fi

cleanup() {
    inst=$1
    if [ $(docker ps -qa --filter Name=${inst} ) ]; then
        docker rm -f ${inst}
    fi
}

cleanup "caddy-v1"
docker run --detach \
           --name "caddy-v1"  \
	   --publish ${HTTPS_PORT}:443 \
	   --publish ${HTTP_PORT}:80 \
           --restart always  \
           --volume /etc/caddy/Caddyfile:/etc/Caddyfile \
           --volume /etc/ssl/caddy:/root/.caddy \
           abiosoft/caddy

