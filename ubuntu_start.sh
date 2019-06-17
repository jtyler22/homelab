#!/bin/bash

# To install:
# $ wget https://github.com/jtyler22/homelab/raw/master/ubuntu_start.sh
# $ chmod +x ubuntu_start.sh
# $ sudo ./ubuntu_start.sh

if [[ $EUID > 0 ]]
  then echo "Script must be run as root."
  exit 1
fi

# Prep for Docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt update
sudo apt install -y \
  openssh-server \
  docker-ce docker-ce-cli containerd.io \
  lxd

# Remove password requirement for sudoers
printf "# Remove password requirement for sudoers\n%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/nopasswd

# Disable password authentication
sudo sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo service sshd restart

# Import key from Github
mkdir -p ~/.ssh
curl https://github.com/jtyler22.keys -o ~/.ssh/authorized_keys

# Disable ufw
sudo ufw disable
