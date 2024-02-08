# Control file for Vagrant configuration

# Define the number of master, worker, and load balancer nodes
NUM_MASTERS = 3
NUM_WORKERS = 1
NUM_LOADBALANCERS = 1

# Define the IP range for each type of node
MASTER_IP_START = "192.168.56.10"
WORKER_IP_START = "192.168.56.20"
LOADBALANCER_IP_START = "192.168.56.30"

# Define CPU and memory for each group of VMs
MASTER_CPU = 2
MASTER_MEMORY = 2048
WORKER_CPU = 1
WORKER_MEMORY = 1024
LOADBALANCER_CPU = 1
LOADBALANCER_MEMORY = 1024
