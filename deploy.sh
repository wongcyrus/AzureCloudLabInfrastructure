#!/usr/bin/env bash
mkdir -p ${LAB}/${EMAIL}
cd ${LAB}/${EMAIL}
rm -rf AzureCloudLabInfrastructure/
git clone https://github.com/wongcyrus/AzureCloudLabInfrastructure
cd AzureCloudLabInfrastructure
git checkout ${BRANCH}
terraform init
terraform apply -auto-approve
terraform output -json > output.json
cat output.json
curl -X POST -F 'output=@output.json' ${CALLBACK_URL}
