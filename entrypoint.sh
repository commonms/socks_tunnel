#!/bin/bash

set -ex

/etc/init.d/ssh start

sshpass -p $TARGET_PROXY_PASS \
    ssh -o ProxyCommand="nc -x $CORPORATE_PROXY_HOST:$CORPORATE_PROXY_PORT %h %p" -o StrictHostKeyChecking=no -R 10022:localhost:22 $TARGET_PROXY_USER@$TARGET_PROXY_HOST -p 443 #\
#        sshpass -p $TARGET_PROXY_PASS \
#            ssh -nNT -o StrictHostKeyChecking=no -D $TARGET_PROXY_HOST:$TARGET_PROXY_PORT $TARGET_PROXY_USER@localhost -p 10022
