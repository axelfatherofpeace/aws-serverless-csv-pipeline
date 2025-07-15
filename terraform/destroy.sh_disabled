#!/bin/bash
set -x

# Recreate zip if needed (adjust relative path!)
cd ../lambda
zip -r ../lambda.zip . > /dev/null
cd ../terraform


#terramform init with the copied terraform state files
terraform init

# Run destroy
terraform plan -destroy

terraform destroy -auto-approve

#Clean up local terraform files
rm -rf terraform/.terraform
rm -f terraform/.terraform.lock.hcl
rm -f terraform/terraform.tfstate
rm -f terraform/terraform.tfstate.backup
rm -f terraform/tfplan 


