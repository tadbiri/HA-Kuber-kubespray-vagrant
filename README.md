# Full Automate HA Kubernetes Environment with Vagrant and Kubespray

## Introduction

This repository provides a fully automated setup for a highly available Kubernetes (K8s) environment using Vagrant and Kubespray. It provisions a Kubernetes cluster with multiple master nodes, a load balancer, and worker nodes using VirtualBox as the provider and Ubuntu 22.04.3 "Jammy Jellyfish" as the base OS. This setup is intended for development and testing purposes.

## Prerequisites

Before you begin, ensure your system meets the following requirements:

- Ubuntu-based operating system with at least 8 CPU cores and 16GB RAM.
- Essential applications: VirtualBox and Vagrant.

### Installing VirtualBox and Vagrant

To run this script on an Ubuntu-based operating system:

1. Open a terminal.
2. Update your package index:

    ```bash
    sudo apt update
    ```

3. Install VirtualBox:

    ```bash
    sudo apt install virtualbox
    ```

4. Download and install Vagrant from the official website or using the following command:

    ```bash
    sudo apt install vagrant
    ```

For other operating systems, refer to the [official Vagrant documentation](https://www.vagrantup.com/docs/installation) for installation instructions.

## Usage

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/tadbiri/HA-Kuber-kubespray-vagrant.git
    ```

2. Navigate to the directory containing the Vagrantfile:

    ```bash
    cd HA-Kuber-kubespray-vagrant
    ```

3. Edit the `control.rb` file to adjust the number of nodes, CPU, memory, and IP configurations as needed.

4. Run the following command to start the VMs and provision the Kubernetes cluster:

    ```bash
    vagrant up
    ```

5. Once the provisioning is complete, log into the load balancer node:

    ```bash
    vagrant ssh kube-lb-1
    ```

6. Run the post setup script to complete the cluster setup:

    ```bash
    sudo /root/post_setup.sh
    ```
## Useful Vagrant Commands

Here are some useful Vagrant commands to manage your VMs:

- **Halt all running VMs**:

    ```bash
    vagrant halt
    ```

- **Reload all VMs (useful after changing the Vagrantfile)**:

    ```bash
    vagrant reload
    ```

- **Destroy all VMs**:

    ```bash
    vagrant destroy -f
    ```

- **SSH into a specific VM**:

    ```bash
    vagrant ssh <vm_name>
    ```

- **Check the status of VMs**:

    ```bash
    vagrant status
    ```

## Files Description

### Vagrantfile

The `Vagrantfile` defines the configuration for creating and provisioning the virtual machines. It sets up master nodes, worker nodes, and load balancers, and configures their CPU, memory, and network settings.

### control.rb

The `control.rb` file contains variables to control the number of master, worker, and load balancer nodes, as well as their CPU, memory, and IP configurations.

### bootstrap.sh

The `bootstrap.sh` script is executed during the provisioning phase of each VM. It installs essential packages, enables root login, and sets up SSH keys for secure communication between nodes.

### post_setup.sh

The `post_setup.sh` script performs additional configuration after the initial setup. It installs necessary packages, configures HAProxy, clones the Kubespray repository, and runs Ansible playbooks to set up the Kubernetes cluster. This script must be run manually on the load balancer node after the VMs are up.

For more detailed descriptions and usage instructions of each script, refer to the respective README files in this repository.

## Notes

- This setup is intended for development and testing purposes only and may not be suitable for production environments.
- Ensure that your system meets the hardware requirements specified in the control file to avoid performance issues.
- Internet access is enabled by default for all VMs to facilitate package installation and updates.

## Additional Information

For further details on each script and its functionality, refer to the individual README files linked below:

- [Vagrantfile README](./Vagrantfile_README.md)
- [control.rb README](./control.rb_README.md)
- [bootstrap.sh README](./bootstrap.sh_README.md)
- [post_setup.sh README](./post_setup.sh_README.md)

By following the instructions and utilizing the provided scripts, you can efficiently set up a fully automated HA Kubernetes environment for your development and testing needs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Contact

For any questions or issues, please open a GitHub issue in this repository.
