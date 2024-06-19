#!/bin/bash

# Install sshpass
sudo apt-get update -qq 
sudo apt-get install -qq -y sshpass 

# Enable root login
echo 'This is Kubernetes master node #{i}'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config   
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config   
sudo systemctl reload sshd
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
chown -R root: /root/.ssh/
echo "root:123456" | sudo chpasswd 

