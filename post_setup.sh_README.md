# post_setup.sh

## Overview

The `post_setup.sh` script performs additional configuration after the initial setup of the virtual machines. This script installs necessary packages, configures HAProxy, clones the Kubespray repository, and runs Ansible playbooks to set up the Kubernetes cluster. This script must be run manually on the load balancer node after the VMs are up.

## Script Details

### Package Installation

- **Install Essential Packages**: Installs `pssh`, `haproxy`, `python3`, `python3-pip`, and `ansible`.

    ```bash
    sudo apt update -qq && sudo apt install -qq -y pssh haproxy python3 python3-pip ansible 
    ```

### HAProxy Configuration

- **Configure HAProxy**: Sets up HAProxy to distribute API server traffic among the master nodes.

    ```bash
    sudo echo "listen kubernetes-apiserver-https
    bind 192.168.56.111:8383
    mode tcp
    option log-health-checks
    timeout client 3h
    timeout server 3h
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
    server kube-master-1 192.168.56.11:6443 check
    server kube-master-2 192.168.56.12:6443 check
    server kube-master-3 192.168.56.13:6443 check
    balance roundrobin" >> /etc/haproxy/haproxy.cfg

    sudo systemctl restart haproxy
    sudo systemctl enable haproxy
    ```

### Kubespray Setup

- **Clone Kubespray Repository**: Clones the Kubespray repository and installs dependencies.

    ```bash
    git clone https://github.com/kubernetes-sigs/kubespray.git /root/kubespray
    cd /root/kubespray
    sudo pip3 install -r requirements.txt
    ```

- **Configure Inventory**: Sets up the Ansible inventory for the Kubernetes cluster.

    ```bash
    sudo cp -rfp inventory/sample inventory/mycluster
    declare -a IPS=("192.168.56.11" "192.168.56.12" "192.168.56.13" "192.168.56.21")
    sudo CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
    ```

- **Run Ansible Playbook**: Executes the Kubespray playbook to install the Kubernetes cluster.

    ```bash
    sudo ansible-playbook -i inventory/mycluster/hosts.yaml --user root cluster.yml
    ```

### Kubectl Setup

- **Install and Configure Kubectl**: Installs `kubectl` and configures it on the load balancer node.

    ```bash
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
    ```

This script completes the setup of the Kubernetes cluster, ensuring all components are properly configured and ready for use.

For more details, refer to the main [README.md](./README.md).
