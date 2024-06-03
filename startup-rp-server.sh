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

# set up reverse proxy
sudo sh -c "cat << EOF > /etc/nginx/sites-available/default
upstream frontend {
        server 192.168.1.9; # frontend server 1
}

server {
        location / {
                proxy_pass http://frontend;
        }
}
EOF"

if [[ $? -ne 0 ]]; then
	echo "failed create reverse proxy config file"
	exit 1
fi

# create the symlink
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

if [[ $? -ne 0 ]]; then
        echo "failed create symlink"
        exit 1
fi

# reload nginx
sudo nginx -s reload
