# control.rb

## Overview

The `control.rb` file contains variables that control the number of master, worker, and load balancer nodes, as well as their CPU, memory, and IP configurations. This file allows you to customize the hardware and network settings for your Kubernetes cluster.

## Variables

### Node Counts

- **NUM_MASTERS**: Number of master nodes.
- **NUM_WORKERS**: Number of worker nodes.
- **NUM_LOADBALANCERS**: Number of load balancer nodes.

### Master Node Configuration

- **MASTER_MEMORY**: Memory allocated to each master node (e.g., `2048` for 2GB).
- **MASTER_CPU**: Number of CPUs allocated to each master node.
- **MASTER_IP_START**: Starting IP address for master nodes (e.g., `192.168.56.11`).

### Worker Node Configuration

- **WORKER_MEMORY**: Memory allocated to each worker node.
- **WORKER_CPU**: Number of CPUs allocated to each worker node.
- **WORKER_IP_START**: Starting IP address for worker nodes.

### Load Balancer Node Configuration

- **LOADBALANCER_MEMORY**: Memory allocated to each load balancer node.
- **LOADBALANCER_CPU**: Number of CPUs allocated to each load balancer node.
- **LOADBALANCER_IP_START**: Starting IP address for load balancer nodes.

## Customization

You can modify these variables to adjust the cluster configuration according to your hardware resources and network requirements.

For more details, refer to the main [README.md](./README.md).
