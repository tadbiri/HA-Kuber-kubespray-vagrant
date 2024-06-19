# Vagrantfile

## Overview

The `Vagrantfile` defines the configuration for creating and provisioning the virtual machines that make up the Kubernetes cluster. It specifies the setup for master nodes, worker nodes, and load balancers, configuring their CPU, memory, and network settings.

## Configuration

- **Base Box**: Uses `ubuntu/jammy64` for Ubuntu 22.04.3.
- **Provider**: VirtualBox.
- **Provisioning**: Executes `bootstrap.sh` script on each VM.

## Nodes Setup

### Master Nodes

Master nodes are defined with the following parameters:
- **Hostname**: `kube-master-<index>`
- **IP Address**: Configured based on `MASTER_IP_START`.
- **Resources**: Configured based on `MASTER_MEMORY` and `MASTER_CPU`.

### Worker Nodes

Worker nodes are defined with the following parameters:
- **Hostname**: `kube-worker-<index>`
- **IP Address**: Configured based on `WORKER_IP_START`.
- **Resources**: Configured based on `WORKER_MEMORY` and `WORKER_CPU`.

### Load Balancer Nodes

Load balancer nodes are defined with the following parameters:
- **Hostname**: `kube-lb-<index>`
- **IP Address**: Configured based on `LOADBALANCER_IP_START`.
- **Resources**: Configured based on `LOADBALANCER_MEMORY` and `LOADBALANCER_CPU`.

## Network Configuration

Each node is assigned a private network IP address. The `/etc/hosts` file on each VM is updated to enable communication between nodes.

## Provisioning Scripts

- **Bootstrap Script**: `bootstrap.sh` is executed to install necessary packages and configure SSH access.
- **Post Setup Script**: `post_setup.sh` is copied to the load balancer node and executed manually to complete the Kubernetes cluster setup.

For more details, refer to the main [README.md](./README.md).
