# AWS provider and region

provider "aws" {
  region = "ap-south-1"
}


# Create a unique S3 bucket
resource "random_id" "rand"{
  byte_length = 4
}

# S3 bucket creation to upload the CSV files
resource "aws_s3_bucket" "csv_bucket" {
  bucket = "csv-upload-bucket-${random_id.rand.hex}"   # Bucket name with random generated hex
  force_destroy = true                                 # Allow bucket deletion even when it has files
}


#Create a DynamoDB table to store parsed CSV data
resource "aws_dynamodb_table" "csv_table" {
  name = "csv-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = id                                  #Partition key , must match the CSV header

attribute {
  name = "id"
  type = "S"                              #For String "N" when Number
}
}


#Create an IAM role that allows lambda to run
resource "aws_iam_role" "lambda_role" {
  name = "lambda_csv_processor_role"
  
  assume_rule_policy = jsonencode({            #who is allowed to assume(use) this role
  version = "2012-10-17",                      #IAM policy ver. always same 
  Statement = [{
    Effect = "Allow",                          #Assume role is allowed
    Principal = {
      Service = "lambda.amazonaws.com"  
},
    Action = "sts:AssumeRole"                  #Lambda is allowed to call security token service to assume the role
}]
})
}



