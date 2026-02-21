#!/usr/bin/env bash

if ip link show work >/dev/null 2>&1; then
    echo '{ "text": "wg-work: UP", "class": "wireguard" }'
else
    echo ""
fi
