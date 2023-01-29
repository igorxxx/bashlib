#!/bin/bash
sudo apt install -y bind9 ntp
echo "**** Config DNS *****"
echo "sudo nano /etc/bind/named.conf"
echo "edit:"
echo "forwarders {"
echo "8.8.8.8;"
echo "8.8.4.4;"
echo "};"