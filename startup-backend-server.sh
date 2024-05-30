#!/bin/bash

# update OS
sudo apt -y update

if [[ $? -ne 0 ]]; then
	echo "failed update OS"
	exit 1
fi

# install nginx
sudo apt install -y nginx

# set up as web server
sudo sh -c 'cat << EOF > /etc/nginx/sites-available/backend-server-1
server {
    server_name backend-server-1 192.168.1.7;

    location / {
        proxy_pass http://localhost:8080;
    }
}
EOF'

if [[ $? -ne 0 ]]; then
	echo "failed set up web server"
	exit 1
fi

# create the symlink
sudo ln -sf /etc/nginx/sites-available/backend-server-1 /etc/nginx/sites-enabled/backend-server-1

if [[ $? -ne 0 ]]; then
	echo "failed create symlink"
	exit 1
fi

# reload nginx
sudo nginx -s reload

# download binary app
sudo curl -O https://raw.githubusercontent.com/aryyawijaya/nginx-rp-lb/main/backend-service/server

# change permission binary app
sudo chmod +x server

# run app
./server
