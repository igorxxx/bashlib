#!/bin/bash
#install nginx
sudo apt install nginx
sudo apt install certbot python3-certbot-nginx
# Install x-ui https://github.com/MHSanaei/3x-ui
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
# sudo certbot --nginx  --register-unsafely-without-email -d example.com
# sudo certbot renew --dry-run

