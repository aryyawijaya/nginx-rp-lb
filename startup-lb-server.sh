#!/bin/bash

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

# set up load balancer
sudo sh -c 'cat << EOF > /etc/nginx/sites-available/default
upstream backend {
	server 192.168.1.7:8080; # backend server 1
	server 192.168.1.6:8080; # backend server 2
}

server {
	location / {
		proxy_pass http://backend;
	}
}
EOF'

if [[ $? -ne 0 ]]; then
	echo "failed create load balancer config file"
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
