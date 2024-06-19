# bootstrap.sh

## Overview

The `bootstrap.sh` script is executed during the provisioning phase of each virtual machine. It performs initial setup tasks, such as installing necessary packages, enabling root login, and configuring SSH keys for secure communication between nodes.

## Script Details

### Package Installation

- **sshpass**: Installs `sshpass` for password-based SSH automation.

    ```bash
    sudo apt-get update -qq 
    sudo apt-get install -qq -y sshpass 
    ```

### SSH Configuration

- **Enable Root Login**: Modifies SSH configuration to enable password authentication and root login.

    ```bash
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config   
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config   
    sudo systemctl reload sshd
    ```

- **Generate SSH Key**: Generates an SSH key for root user and sets a password.

    ```bash
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
    chown -R root: /root/.ssh/
    echo "root:123456" | sudo chpasswd 
    ```

This script ensures that each VM is ready for secure communication and further configuration.

For more details, refer to the main [README.md](./README.md).
