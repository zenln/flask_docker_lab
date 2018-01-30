#!/bin/bash
# Install terraform

curl -s https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_linux_amd64.zip | gzip -d - > ./terraform
chmod 755 ./terraform
sudo mv terraform /usr/local/bin
