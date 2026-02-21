#!/usr/bin/env bash

while true
do
    systemctl is-active --quiet wg-quick-work.service
    status=$?
    if [[ status -eq 0 ]]; then
        echo '{ "text": "wg-work: UP", "class": "wireguard" }'
    else
        echo ""
    fi
done
