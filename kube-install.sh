#!/bin/bash

#Kubectl version | grep "Server Version"

if kubectl version | grep -q "Server Version";

then

echo "...................kubernetes already installed................."

else

echo "########## kubernetes not found in this machine lets install #########"

echo "###### enter versions to get started #######"

read -p "please enter desired version of kubeadm:" kubeadmversion

read -p "please enter desired version of kubectl:" kubectlversion
 
read -p "please enter desired version of kubelet:" kubeletversion

sudo apt-get update

echo "swapoff"

swapoff -a

echo "Installing sshpass "

sudo apt-get install -y sshpass   

echo "openssh server installation"
sudo apt-get install -y openssh-server

sudo apt-get update
echo "Docker installtion"

sudo apt-get install -y docker.io

sudo apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

sleep 20s

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

echo "Installing kubeadm kubelet kubectl"

sudo apt-get install -y kubeadm=$kubeadmversion kubectl=$kubectlversion kubelet=$kubeletversion

apt-mark hold kubelet kubeadm kubectl


echo "Restart kubelet"

systemctl daemon-reload
systemctl restart kubelet

sudo apt-get update

echo "Execute sucessfully"

# initialize cluster

kubeadm init

# copy the credentials to your user

sudo mkdir -p $HOME/.kube
sudo cat /etc/kubernetes/admin.conf > $HOME/.kube/config
sudo chmod 600 $HOME/.kube/config

# install networking

kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# let master node be used as regular node (put pods there) (optional)

kubectl taint nodes --all node-role.kubernetes.io/master-


fi
