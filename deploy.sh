#!/usr/bin/env bash
mkdir -p ${LAB}/${STUDENT_ID}
cd ${LAB}/${STUDENT_ID}
rm -rf AzureCloudLabInfrastructure/
git clone https://github.com/wongcyrus/AzureCloudLabInfrastructure
cd AzureCloudLabInfrastructure
terraform init
terraform apply -auto-approve
terraform output -json > output.json
