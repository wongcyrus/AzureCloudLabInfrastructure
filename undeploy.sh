#!/usr/bin/env bash
cd ${LAB}/${STUDENT_ID}/AzureCloudLabInfrastructure
ls
terraform refresh
terraform destroy -auto-approve
cd ../../..
rm -rf ${LAB}/${STUDENT_ID}
