#!/bin/bash

function ssh_tunnel_R {
# $1  - Local Port
# $2  - Remote Port
# $3  - Remote SSH User
# $4  - Remote SSH Host
# $5  - RemoteAddress
# Example
# ssh_tunnel_R 22 2222 remuser server.com 127.0.0.1:
    local CMD="ssh -oStrictHostKeyChecking=no -oTCPKeepAlive=yes -oServerAliveInterval=60 -oServerAliveCountMax=3 -f -N -T -i/root/.ssh/id_rsa -R $5$2:127.0.0.1>    pgrep -f "$CMD" &>/dev/null || $CMD
    RES="$(ssh $3@$4 testport $2)"
    if [ "$RES" = "ONLINE" ]; then
      echo  "Done $1->$2 $4"
    else
       echo "Restart Connect $1->$2 $4"
       pkill -f -x "$CMD"
       $CMD
    fi
}