#!/bin/bash
if [[ $EUID > 0 ]]
  then echo "Script must be run as root."
  exit 1
fi
apt update
apt upgrade -y
apt install -y \
  openssh-server

# Remove password requirement for sudoers
printf "# Remove password requirement for sudoers\n%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/nopasswd

# Disable password authentication
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
service sshd restart

# Import key from Github
mkdir -p ~/.ssh
curl https://github.com/jtyler22.keys -o ~/.ssh/authorized_keys

# Disable ufw
ufw disable
