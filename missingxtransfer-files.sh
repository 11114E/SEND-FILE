#!/bin/bash

# Define the username and password
USERNAME="user"
PASSWORD="1"
SOURCE_FILES=(
  "node-2.0.5-linux-amd64.dgst"
  "node-2.0.5-linux-amd64.dgst.sig.1"
  "node-2.0.5-linux-amd64.dgst.sig.2"
  "node-2.0.5-linux-amd64.dgst.sig.4"
  "node-2.0.5-linux-amd64.dgst.sig.5"
  "node-2.0.5-linux-amd64.dgst.sig.7"
  "node-2.0.5-linux-amd64.dgst.sig.9"
  "node-2.0.5-linux-amd64.dgst.sig.13"
  "node-2.0.5-linux-amd64.dgst.sig.14"
  "node-2.0.5-linux-amd64.dgst.sig.16"
  "node-2.0.5-linux-amd64"
)
DEST_DIR="/home/user"

# List of IP addresses
IP_ADDRESSES=(
  172.16.6.9
172.16.6.181
172.16.6.182
172.16.6.185
172.16.6.186
172.16.6.188
172.16.6.163
172.16.6.176
172.16.6.167
172.16.6.171
172.16.6.170
172.16.6.174
172.16.6.172
172.16.6.173
172.16.6.183
172.16.6.187
172.16.6.138
172.16.6.177
172.16.6.178
172.16.6.191
172.16.6.190
172.16.6.189
172.16.6.179
172.16.6.180
)

# Loop through each IP and transfer the files
for IP in "${IP_ADDRESSES[@]}"; do
  echo "Transferring files to $IP..."
  
  for FILE in "${SOURCE_FILES[@]}"; do
    /usr/bin/expect <<EOF
    log_user 1
    spawn ssh -o StrictHostKeyChecking=no $USERNAME@$IP "[ -f $DEST_DIR/$FILE ] && echo 'File exists'"
    expect {
      "password:" { send "$PASSWORD\r"; exp_continue }
      "yes/no" { send "yes\r"; exp_continue }
    }
    expect eof
EOF

    /usr/bin/expect <<EOF
    log_user 1
    spawn scp -o StrictHostKeyChecking=no /root/ceremonyclient/node/$FILE $USERNAME@$IP:$DEST_DIR
    expect {
      "password:" { send "$PASSWORD\r"; exp_continue }
      "yes/no" { send "yes\r"; exp_continue }
    }
    expect eof
EOF
  done
  
  if [ $? -eq 0 ]; then
    echo "Files transferred to $IP successfully."
  else
    echo "Failed to transfer files to $IP."
  fi
done
