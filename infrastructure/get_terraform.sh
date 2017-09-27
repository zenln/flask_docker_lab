TERRAFORM_VERSION=0.10.6
curl -s https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | gzip - -d > ./terraform
chmod 755 ./terraform
