#!/usr/bin/env bash
cd ${LAB}/${EMAIL}/AzureCloudLabInfrastructure
ls
terraform refresh
terraform destroy -auto-approve
cd ../../..
rm -rf ${LAB}/${EMAIL}
curl -d "output=nothing" ${CALLBACK_URL}
