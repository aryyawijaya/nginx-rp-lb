#!/bin/bash

# download binary app
sudo curl -O https://raw.githubusercontent.com/aryyawijaya/nginx-rp-lb/main/backend-service/server

# change permission binary app
sudo chmod +x server

# run app
./server
