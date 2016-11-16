#!/bin/bash

set -ex

/etc/init.d/ssh start

sshpass -p $TARGET_PROXY_PASS \
    ssh -o ProxyCommand="corkscrew $CORPORATE_PROXY_HOST $CORPORATE_PROXY_PORT %h %p" -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 10022:localhost:443 $TARGET_PROXY_USER@$TARGET_PROXY_HOST -p 443 \
        sshpass -p $CONTAINER_PASS \
            ssh -nNT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ServerAliveInterval=60 -D $TARGET_PROXY_HOST:$TARGET_PROXY_PORT $CONTAINER_USER@localhost -p 10022
