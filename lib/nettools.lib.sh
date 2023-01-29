#!/bin/bash
# $1 - url
function test-url {
    curl -Is https://pctuner.club | head -n 1
}

function test_if() {
ip link show $1 | grep -q 'state $2'
}

# $1 A - Add D - Delete
# $2 interface 1
# $3 interfase 2



function change-iproute {
   iptables -$1 FORWARD -i $2 -j ACCEPT; iptables -t nat -A POSTROUTING -o  $3 -j MASQUERADE
}