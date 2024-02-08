# Kubernetes Environment Setup with Vagrant

This Vagrant script automates the setup of a Kubernetes cluster with multiple master nodes, a load balancer, and a worker node using VirtualBox as the provider and Ubuntu 22.04.3 "Jammy Jellyfish" as the base OS.

## Files

- **Vagrantfile**: Defines the configuration for creating and provisioning the virtual machines.
- **control.rb**: Contains variables to control the number of master, worker, and load balancer nodes, as well as their CPU, memory, and IP configurations.

## Prerequisites

### Installing Vagrant

To run this script on an Ubuntu-based operating system:

1. Open a terminal.
2. Update your package index:

    ```
    sudo apt update
    ```

3. Install VirtualBox:

    ```
    sudo apt install virtualbox
    ```

4. Download and install Vagrant from the official website or using the following command:

    ```
    sudo apt install vagrant
    ```

For other operating systems, refer to the [official Vagrant documentation](https://www.vagrantup.com/docs/installation) for installation instructions.

## Usage

1. Clone this repository to your local machine:

    ```
    git clone <repository_url>
    ```

2. Navigate to the directory containing the Vagrantfile:

    ```
    cd kubernetes-vagrant-setup
    ```

3. Edit the `control.rb` file to adjust the number of nodes, CPU, memory, and IP configurations as needed.

4. Run the following command to start the VMs and provision the Kubernetes cluster:

    ```
    vagrant up
    ```

5. Once the provisioning is complete, you can access the VMs individually using SSH:

    ```
    vagrant ssh <vm_name>
    ```

## Notes

- This setup is intended for development and testing purposes only and may not be suitable for production environments.
- Ensure that your system meets the hardware requirements specified in the control file to avoid performance issues.
- Internet access is enabled by default for all VMs to facilitate package installation and updates.
