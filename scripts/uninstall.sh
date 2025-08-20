#!/bin/bash



set -e

# variables
KEYS_DIR="$HOME/.ssh"
source "./ansible/cluster.env"

# destroy all vms
echo  -e "\033[1;31m# Destroying VMs\033[0m"
vagrant destroy -f



# delete ssh keys configuration
rm -r "$KEYS_DIR/vagrant_keys"
rm "$KEYS_DIR/config"
rm "./ansible/inventory"


# Delete nodes IP addresses from known hosts
for i in $(seq 1 "$NUM_MASTERS"); do
ssh-keygen -f "$KEYS_DIR/known_hosts" -R "10.0.1.$((i+10))"
done
for i in $(seq 1 "$NUM_WORKERS"); do
ssh-keygen -f "$KEYS_DIR/known_hosts" -R "10.0.1.$((i+100))"
done


rm "./ansible/cluster.env"



