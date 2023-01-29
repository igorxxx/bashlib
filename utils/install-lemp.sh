#!/bin/bash
apt update
apt full-upgrade
add-apt-repository ppa:sergey-dryabzhinsky/backports
add-apt-repository ppa:sergey-dryabzhinsky/php53
apt update
apt install -y mc curl wget zip openvpn nginx
apt install -y php53-fpm php53-mod-openssl php53-mod-curl php53-mod-posix php53-mod-mysql php53-mod-json php53-mod-mbstring
