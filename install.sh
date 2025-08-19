#!/bin/bash


set -e

# variables
KEYS_DIR="$HOME/.ssh/vagrant_keys"
CONFIG_FILE="$HOME/.ssh/config"
INVENTORY_FILE="./ansible/inventory"
NUM_MASTERS=1
NUM_WORKERS=2


for arg in "$@"; do
  case $arg in
    --masters=*)
      NUM_MASTERS="${arg#*=}"
      shift
      ;;
    --workers=*)
      NUM_WORKERS="${arg#*=}"
      shift
      ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
  esac
done

touch "$HOME/cluster.env"

# Save cluster size to cluster.env
cat > "$HOME/.ssh/cluster.env" <<EOF
NUM_MASTERS=$NUM_MASTERS
NUM_WORKERS=$NUM_WORKERS
EOF

# Directory for SSH keys and File for config
mkdir -p "$KEYS_DIR"
touch "$CONFIG_FILE"
touch "$INVENTORY_FILE"

# add the correct configuration to config file
cat >> "$INVENTORY_FILE" <<EOF
[masters]
EOF
for i in $(seq 1 "$NUM_MASTERS"); do

# ssh key generation fo masters
ssh-keygen -t rsa -b 4096 -f "$KEYS_DIR/master${i}_key" -N "" <<< y >/dev/null 2>&1

# config file edit for masters
cat >> "$CONFIG_FILE" <<EOF
Host master${i}
  HostName 10.0.1.1$((i-1))
  User vagrant
  IdentityFile $KEYS_DIR/master${i}_key
EOF
cat >> "$INVENTORY_FILE" <<EOF
master${i}
EOF
done

cat >> "$INVENTORY_FILE" <<EOF
[workers]
EOF
for i in $(seq 1 "$NUM_WORKERS"); do

# ssh key generation for workers
ssh-keygen -t rsa -b 4096 -f "$KEYS_DIR/worker${i}_key" -N "" <<< y >/dev/null 2>&1

# config file edit for workers
cat >> "$CONFIG_FILE" <<EOF
Host worker${i}
  HostName 10.0.2.1$((i-1))
  User vagrant
  IdentityFile $KEYS_DIR/worker${i}_key
EOF
cat >> "$INVENTORY_FILE" <<EOF
worker${i}
EOF
done

cat >> "$INVENTORY_FILE" <<EOF
[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

chmod 600 "$CONFIG_FILE"

# run vagrant
echo  -e "\033[1;32m# Provisioning VMs\033[0m"
vagrant up