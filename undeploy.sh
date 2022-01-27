#!/usr/bin/env bash
cd ${STUDENT_ID}/AzureCloudLabInfrastructure
terraform destroy -auto-approve
cd ../..
rm -rf ${STUDENT_ID}
