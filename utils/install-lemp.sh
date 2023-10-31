#!/bin/bash
apt update
apt full-upgrade
add-apt-repository ppa:sergey-dryabzhinsky/backports
add-apt-repository ppa:sergey-dryabzhinsky/php53
add-apt-repository ppa:sergey-dryabzhinsky/packages
wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
dpkg -i mysql-apt-config_0.8.12-1_all.deb
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
apt update
apt install -y mc curl wget zip openvpn nginx
apt install -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
apt install -y php53-fpm php53-mod-openssl php53-mod-curl php53-mod-posix php53-mod-mysql php53-mod-json php53-mod-mbstring
