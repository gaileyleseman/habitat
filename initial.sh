#!/bin/bash

# Install Ansible
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# SSH Server
sudo apt install openssh-server
sudo systemctl enable ssh