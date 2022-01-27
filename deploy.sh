#!/usr/bin/env bash
mkdir ${STUDENT_ID}
cd ${STUDENT_ID}
rm -rf AzureCloudLabInfrastructure/
git clone https://github.com/wongcyrus/AzureCloudLabInfrastructure
cp terraform.tfvars AzureCloudLabInfrastructure/
cd AzureCloudLabInfrastructure
terraform init
terraform apply -auto-approve
