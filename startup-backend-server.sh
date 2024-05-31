#!/bin/bash

# set static IP backend server
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

# download binary app
sudo curl -O https://raw.githubusercontent.com/aryyawijaya/nginx-rp-lb/main/backend-service/server

# change permission binary app
sudo chmod +x server

# run app
./server
