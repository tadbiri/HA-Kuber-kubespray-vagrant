#!/bin/bash

echo "####################################### Post_Script: Start"
# pre setup 

sudo apt update -qq && sudo apt install -qq -y pssh haproxy python3 python3-pip ansible 

# Define the file path for the Nodes list
cd /root
nodes_list_file="./nodeslist.txt"

# Remove any existing IP list file
if [ -f $nodes_list_file ]; then
  rm -rf $nodes_list_file
fi

touch $nodes_list_file
echo "####################################### Post_Script: Start Creating Cluster Nodes list file"
# extract nodes list file from /etc/hosts
vm=$(cat /etc/hosts | grep kube | awk '{print $2}')
echo "$vm" > $nodes_list_file
sed -i 's/^/root@/g' $nodes_list_file 

# Print completion message
echo "####################################### Post_Script: IP list generated at $nodes_list_file"

# Copy SSH Key to all nodes
#ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
for i in $(cat ./nodeslist.txt); do sshpass -p '123456' scp -o StrictHostKeyChecking=no /root/.ssh/id_rsa.pub $i:/root/.ssh/authorized_keys; done  
echo "####################################### Post_Script: Copy ssh key to all nodes has been done"

# Disable swap area on all nodes
for i in $(cat ./nodeslist.txt); do sudo swapoff -a; done
#sudo parallel-ssh -h nodeslist.txt -i "swapoff -a"
echo "####################################### Post_Script: Disable swap area on all nodes has been done"

# make masters name and ip and save it in variables
master1=$(cat /etc/hosts | grep kube-master-1 | awk '{print $2}')
master2=$(cat /etc/hosts | grep kube-master-2 | awk '{print $2}')
master3=$(cat /etc/hosts | grep kube-master-3 | awk '{print $2}')
master1ip=$(cat /etc/hosts | grep kube-master-1 | awk '{print $1}')
master2ip=$(cat /etc/hosts | grep kube-master-2 | awk '{print $1}')
master3ip=$(cat /etc/hosts | grep kube-master-3 | awk '{print $1}')
worker1ip=$(cat /etc/hosts | grep kube-worker-1 | awk '{print $1}')

#echo -e "127.0.0.1  localhost       localhost.localdomain \n\n192.168.56.111 kube-lb-1 kube-lb-1.tedcluster.com\n" > hosts
#for i in $(cat ./nodeslist.txt); do sshpass -p '123456' scp -o StrictHostKeyChecking=no hosts $i:/etc/; done  

# Modify configuration file of HAProxy to enable external LoadBalancer
  sudo echo "listen kubernetes-apiserver-https
  bind 192.168.56.111:8383
  mode tcp
  option log-health-checks
  timeout client 3h
  timeout server 3h
  default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
  server "${master1}" "${master1ip}":6443 check
  server "${master2}" "${master2ip}":6443 check
  server "${master3}" "${master3ip}":6443 check
  balance roundrobin" >> /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy
sudo systemctl enable haproxy

echo "####################################### Post_Script: Configuring HAProxy has been done"


# Remove any existing kubespray directory and create new one
kubespray_dir="./kubespray"
if [ -d $kubespray_dir ]; then
  rm -rf $kubespray_dir
fi
mkdir $kubespray_dir

# Clone official Kubespray repository
echo "####################################### Post_Script: Start Cloning Kubespray Repo"
git clone https://github.com/kubernetes-sigs/kubespray.git $kubespray_dir
echo "####################################### Post_Script: Cloning Kubespray Repo Finished"

cd kubespray
# Install dependencies from ``requirements.txt``
sudo pip3 install -r requirements.txt
# Copy ``inventory/sample`` as ``inventory/mycluster``
sudo cp -rfp inventory/sample inventory/mycluster
# Update Ansible inventory file with inventory builder
declare -a IPS=("${master1ip}" "${master2ip}" "${master3ip}" "${worker1ip}")
sudo CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sudo echo '
all:
  hosts:
    kube-master-1:
      ansible_host: 192.168.56.11
      ip: 192.168.56.11
      access_ip: 192.168.56.11
      ansible_connection: ssh
      ansible_user: root
    kube-master-2:
      ansible_host: 192.168.56.12
      ip: 192.168.56.12
      access_ip: 192.168.56.12
      ansible_connection: ssh
      ansible_user: root
    kube-master-3:
      ansible_host: 192.168.56.13
      ip: 192.168.56.13
      access_ip: 192.168.56.13
      ansible_connection: ssh
      ansible_user: root
    kube-worker-1:
      ansible_host: 192.168.56.21
      ip: 192.168.56.21
      access_ip: 192.168.56.21
      ansible_connection: ssh
      ansible_user: root
  children:
    kube-master:
      hosts:
        kube-master-1:
        kube-master-2:
        kube-master-3:
    kube_node:
      hosts:
        kube-master-1:
        kube-master-2:
        kube-master-3:
        kube-worker-1:
    etcd:
      hosts:
        kube-master-1:
        kube-master-2:
        kube-master-3:
    k8s_cluster:
      children:
        kube-master:
        kube_node:
    calico_rr:
      hosts: {}' > inventory/mycluster/hosts.yaml


sudo chown -R root: /root/


sudo sed -i 's/# loadbalancer_apiserver_localhost: true/loadbalancer_apiserver_localhost: false/' inventory/mycluster/group_vars/all/all.yml

sudo echo '
## External LB example config
apiserver_loadbalancer_domain_name: kube-lb-1.tedcluster.com
loadbalancer_apiserver:
  address: 192.168.56.111
  port: 8383' >>  inventory/mycluster/group_vars/all/all.yml

sudo sed -i 's/cluster.local/tedcluster.com/' inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml


# Start installing k&s cluster with ansible kubespray
sudo ansible-playbook -i inventory/mycluster/hosts.yaml --user root cluster.yml

#Install and config kubectl on lb
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg 
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list 
sudo apt-get update
sudo apt-get install -y kubectl
sudo mkdir ~/.kube
sudo scp -r root@kube-master-1:/etc/kubernetes/admin.conf ~/.kube/config

sudo kubectl get all -A

# Install kubectx and kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

