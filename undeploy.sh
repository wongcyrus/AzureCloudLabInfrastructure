#!/usr/bin/env bash
az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}
cd ${LAB}/${EMAIL}/AzureCloudLabInfrastructure
ls
mkdir -p $HOME/.terraform.d/plugin-cache
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
terraform init
terraform refresh
terraform destroy -auto-approve
cd ../../..
rm -rf ${LAB}/${EMAIL}
curl -d "output=nothing" ${CALLBACK_URL}
