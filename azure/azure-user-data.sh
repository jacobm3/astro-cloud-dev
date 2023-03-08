#!/bin/bash

hostnamectl set-hostname ${hostname}

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y \
  bzip2 \
  git \
  htop \
  iotop \
  jq \
  net-tools \
  netcat \
  nmap \
  python3-pip \
  sysstat \
  tree \
  unzip \
  vim-nox 

pip install --upgrade pip

# Install Astro CLI
curl -sSL install.astronomer.io | bash -s

HM=/home/ubuntu

# add environment
cd $HM
git clone https://github.com/jacobm3/gbin.git
chmod +x gbin/*

echo '. ~/gbin/jacobrc'  >> $HM/.bashrc
ln -s $HM/gbin/jacobrc $HM/.jacobrc

chown -R $USER:$USER $HM

cd $HM/gbin && cp pg ng /usr/local/bin && ./vim.sh 
cd $HM


# Install Docker CE
apt-get remove docker docker-engine docker.io containerd runc
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# add ubuntu user to docker group
usermod -a -G docker ubuntu

cd $HM && sudo -u ubuntu git clone https://github.com/jacobm3/astro-super-dev.git
mv astro-super-dev astro && cd astro
sudo -u ubuntu git checkout just-nginx
rm -fr astro-dev

chown -R ubuntu $HM

sudo -u ubuntu ./start-astro-dev-stack.sh
