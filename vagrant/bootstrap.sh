#!/bin/bash
sudo apt-get update -y

sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update -y
sudo apt-get install terraform -y

sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

echo "-----> OK: Terraform y Ansible están listos."