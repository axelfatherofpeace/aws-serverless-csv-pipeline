#!/bin/bash

#BUCKET_NAME="csv-upload-bucket-1077932e"

# Get the bucket name from Terraform output
BUCKET_NAME=$(terraform -chdir=terraform output -raw s3_bucket_name)

aws s3 cp ../sample.csv s3://$BUCKET_NAME/

if [ $? -eq 0 ];then
  echo "Uplaod Success"
else
  echo "Failed Upload"
fi  
