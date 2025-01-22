#!/bin/bash

# Update the system
sudo yum update -y

# Install Git
sudo yum install -y git

# Install dependencies for Terraform
sudo yum install -y wget unzip

# Download the latest version of Terraform
TERRAFORM_VERSION="1.6.0"  # Change this version as needed
cd /tmp
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Unzip and install Terraform
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify installations
terraform -version
git --version

# Clean up
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "Terraform and Git have been successfully installed."
