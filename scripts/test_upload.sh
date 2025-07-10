#!/bin/bash

BUCKET_NAME="csv-upload-bucket-573a2219"

# Get the bucket name from Terraform output
#TF_DIR="../terraform"
#BUCKET_NAME=$(terraform -chdir=$TF_DIR output -raw s3_bucket_name)

aws s3 cp ../sample.csv s3://$BUCKET_NAME/

if [ $? -eq 0 ];then
  echo "Uplaod Success"
else
  echo "Failed Upload"
fi  
