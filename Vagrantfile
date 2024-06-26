# Load control file
require_relative 'control'

Vagrant.configure("2") do |config|

  config.vm.provision "shell", path: "bootstrap.sh"
  # Define the box and provider (VirtualBox) with Ubuntu Jammy version 22.04.3
  config.vm.box = "ubuntu/jammy64"
  #config.vm.box_version = "20220120.0.0"
  # Disable box update checks to prevent errors when the box doesn't exist locally
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  # Define the master nodes
  (1..NUM_MASTERS).each do |i|
    config.vm.define "kube-master-#{i}" do |node|
      node.vm.hostname = "kube-master-#{i}"
      node.vm.network "private_network", ip: "#{MASTER_IP_START.split('.')[0..2].join('.')}." + "#{MASTER_IP_START.split('.')[3].to_i + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "kube-master-#{i}"
        vb.memory = MASTER_MEMORY
        vb.cpus = MASTER_CPU
      end
    end 
  end

  # Define the worker nodes
  (1..NUM_WORKERS).each do |i|
    config.vm.define "kube-worker-#{i}" do |node|
      node.vm.hostname = "kube-worker-#{i}"
      node.vm.network "private_network", ip: "#{WORKER_IP_START.split('.')[0..2].join('.')}." + "#{WORKER_IP_START.split('.')[3].to_i + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "kube-worker-#{i}"
        vb.memory = WORKER_MEMORY
        vb.cpus = WORKER_CPU
      end
    end
  end

  # Define the load balancer nodes
  (1..NUM_LOADBALANCERS).each do |i|
    config.vm.define "kube-lb-#{i}" do |node|
      node.vm.hostname = "kube-lb-#{i}"
      node.vm.network "private_network", ip: "#{LOADBALANCER_IP_START.split('.')[0..2].join('.')}." + "#{LOADBALANCER_IP_START.split('.')[3].to_i + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "kube-lb-#{i}"
        vb.memory = LOADBALANCER_MEMORY
        vb.cpus = LOADBALANCER_CPU
      end
      # Copy post_setup.sh on the load balancer node
      node.vm.provision "file", source: "./post_setup.sh", destination: "/home/vagrant/post_setup.sh"
      node.vm.provision "shell", inline: "sudo cp /home/vagrant/post_setup.sh /root"
      node.vm.provision "shell", inline: "sudo chown root: /root/post_setup.sh"
      node.vm.provision "shell", inline: "sudo chmod +x /root/post_setup.sh"
    end
  end
  
  # Enable internet access from VMs
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  # Update /etc/hosts on each VM to enable communication between them
  config.vm.provision "shell", inline: "sudo echo '127.0.0.1	localhost\n\n' > /etc/hosts"
  config.vm.provision "shell", inline: "sudo sed -i '/kube-master-/d' /etc/hosts"
  config.vm.provision "shell", inline: "sudo sed -i '/kube-lb-/d' /etc/hosts"
  config.vm.provision "shell", inline: "sudo sed -i '/kube-worker-/d' /etc/hosts"
  (1..NUM_MASTERS).each do |i|
    master_ip = "#{MASTER_IP_START.split('.')[0..2].join('.')}." + "#{MASTER_IP_START.split('.')[3].to_i + i}"
    config.vm.provision "shell", inline: "sudo echo '#{master_ip} kube-master-#{i} kube-master-#{i}.tedcluster.com' >> /etc/hosts"
  end
  (1..NUM_WORKERS).each do |i|
    worker_ip = "#{WORKER_IP_START.split('.')[0..2].join('.')}." + "#{WORKER_IP_START.split('.')[3].to_i + i}"
    config.vm.provision "shell", inline: "sudo echo '#{worker_ip} kube-worker-#{i} kube-worker-#{i}.tedcluster.com' >> /etc/hosts"
  end
  (1..NUM_LOADBALANCERS).each do |i|
    lb_ip = "#{LOADBALANCER_IP_START.split('.')[0..2].join('.')}." + "#{LOADBALANCER_IP_START.split('.')[3].to_i + i}"
    config.vm.provision "shell", inline: "sudo echo '#{lb_ip} kube-lb-#{i} kube-lb-#{i}.tedcluster.com' >> /etc/hosts"
  end

end