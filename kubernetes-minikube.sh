#!/bin/bash

# Check for 2 or more CPUs, 2GB of free memory, 20GB of free disk space

echo "Checking system resources..."

# Check for disk space availability
if [ $(( $(df -m | grep '/$' | awk '{ print $4 }') / 1024 )) -le 20 ]; then
    echo "Insufficient disk space"
    exit 9
fi

# Check for system memory
if [ $(( $(free -m | grep 'Mem' | awk '{ print $4 }') / 1024 )) -le 2 ]; then
    echo "Insufficient memory"
    exit 8
fi

# Check for CPUs
if [ $(lscpu | grep 'CPU(s):' | head -n 1 | awk '{ print $2 }') -lt 2 ]; then
    echo "2 or more CPUs required"
    exit 7
fi

OS_NAME=$(hostnamectl | grep -i 'Operating System' | awk '{ print $3 }')
OS_VERSION=$(hostnamectl | grep -i 'Operating System' | awk '{ print $4 }')

if [ $OS_NAME = "CentOS" ]; then
    # Remove old docker versions
    sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
    # Install latest docker version
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io
    # Start docker
    sudo systemctl start docker

    # install curl
    sudo yum install curl

    # install kubernetes
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Install minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi

if [ $OS_NAME = "Ubuntu" ] && [[ $OS_VERSION = "21.10" || $OS_VERSION = "21.04" ]]; then
    # Remove old docker versions
    sudo apt-get remove docker docker-engine docker.io containerd runc
    # Install latest docker version
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

    # install kubernetes
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Install minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi


