#!/usr/bin/env bash
az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}
mkdir -p ${LAB}/${EMAIL}
cd ${LAB}/${EMAIL}
rm -rf AzureCloudLabInfrastructure/
git clone http://github.com/wongcyrus/AzureCloudLabInfrastructure
cd AzureCloudLabInfrastructure
git checkout ${BRANCH}
terraform init
terraform apply -auto-approve
terraform output -json | jq 'with_entries(.value |= .value)'> output.json
cat output.json
curl -X POST -H "Content-Type: application/json" -d @output.json ${CALLBACK_URL}
