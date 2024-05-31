#!/bin/bash

# set static IP lb server
if [[ -z "$1" ]]; then
        echo "must set ip address"
        exit 1
fi
if [[ -z "$2" ]]; then
        echo "must set gateway"
        exit 1
fi

IP_WITH_PREFIX="$1"
IP=$(echo "$IP_WITH_PREFIX" | cut -d '/' -f 1)
PREFIX_LENGTH=$(echo "$IP_WITH_PREFIX" | cut -d '/' -f 2)

if ! [[ "$PREFIX_LENGTH" =~ ^[0-9]+$ ]]; then
    echo "Invalid prefix length: $PREFIX_LENGTH"
    exit 1
fi

sudo sh -c "cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses: [$IP/$PREFIX_LENGTH]
      gateway4: $2
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF"

sudo netplan apply

if [[ $? -ne 0 ]]; then
        echo "failed to set static IP"
        exit 1
fi

# update OS
sudo apt -y update

if [[ $? -ne 0 ]]; then
        echo "failed to update OS"
        exit 1
fi

# install nginx
sudo apt install -y nginx

if [[ $? -ne 0 ]]; then
        echo "failed install nginx"
        exit 1
fi

# set up web server
# sudo mkdir -p /var/www/fe-aryya-1.id/html

# sudo chown -R $USER:$USER /var/www/fe-aryya-1.id/html

# sudo chmod -R 755 /var/www/fe-aryya-1.id

sudo sh -c 'curl -Lo repo.zip https://github.com/aryyawijaya/nginx-rp-lb/archive/refs/heads/main.zip \
	&& unzip -o repo.zip \
	&& cp -r ./nginx-rp-lb-main/frontend-service/dist/* /var/www/html/'

# sudo sh -c 'cat << EOF > /etc/nginx/sites-available/fe-aryya-1.id
# server {
#        listen 80;
#        listen [::]:80;
#
#        root /var/www/fe-aryya-1.id/html;
#        index index.html index.htm index.nginx-debian.html;
#
#        server_name fe-aryya-1.id www.fe-aryya-1.id;
#
#        location / {
#                try_files $uri $uri/ =404;
#        }
#}
#EOF'

# sudo ln -sf /etc/nginx/sites-available/fe-aryya-1.id /etc/nginx/sites-enabled/

sudo nginx -s reload
