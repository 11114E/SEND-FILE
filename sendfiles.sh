#!/bin/bash

REMOTE_HOSTS=("172.16.6.16" "192.168.1.101" "192.168.1.102")
LOCAL_REPO="/home/user/node-2.0.0.4-linux-amd64"
REMOTE_PATH="/home/user/"

for HOST in "${REMOTE_HOSTS[@]}"; do
    sudo scp -r $LOCAL_REPO user@$HOST:$REMOTE_PATH
done
