############################ AWS provider and region
provider "aws" {
  region = "ap-south-1"
}


####################################### Create a unique S3 bucket
resource "random_id" "rand"{
  byte_length = 4
}


################################ S3 bucket creation to upload the CSV files
resource "aws_s3_bucket" "csv_bucket" {
  bucket = "csv-upload-bucket-${random_id.rand.hex}"   # Bucket name with random generated hex
  force_destroy = true                                 # Allow bucket deletion even when it has files
}


########################### Create a DynamoDB table to store parsed CSV data
resource "aws_dynamodb_table" "csv_table" {
  name = "csv-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"                                  #Partition key , must match the CSV header

  attribute {
    name = "id"
    type = "S"                              #For String "N" when Number
}
}


################################# Create an IAM role that allows lambda to run
resource "aws_iam_role" "lambda_role" {
  name = "lambda_csv_processor_role"
  
  assume_role_policy = jsonencode({            #who is allowed to assume(use) this role
  Version = "2012-10-17",                      #IAM policy ver. always same 
  Statement = [{
    Effect = "Allow",                          #Assume role is allowed
    Principal = {
      Service = "lambda.amazonaws.com"  
},
    Action = "sts:AssumeRole"                  #Lambda is allowed to call security token service to assume the role
}]
})
}


################################ Give lambda permission to read from s3 ,write to DynamoDB and log to cloudwatch
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_csv_permissions"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
   
    
    Statement = [                                         #list of permissions to be allowed
      {                                                  
        Effect = "Allow"                                  #DynamoDB 
        Action = ["dynamodb:PutItem"],                    #insert permission to dynamodb
        Resource = aws_dynamodb_table.csv_table.arn       #target dynamodb table
      },

      
      {
        Effect = "Allow"                                       #S3 Bucket
        Action = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.csv_bucket.arn}/*"         #All the files in the bucket
      },

      
      {
        Effect = "Allow"                                 #Cloudwatch
        Action = [                                       #Logging actions
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"                                 #Allow logs for all resources
      }
]
})
}

########################################## Create lambda function from lambda.zip
resource "aws_lambda_function" "csv_processor" {
  function_name = "csv-processor-lambda"                  #Name of the lambda function
  
  filename = "../lambda.zip"                              #path to the zipped lambda function
  source_code_hash = filebase64sha256("../lambda.zip")    #ensures versioned new deployment if any code changes

  handler = "process_csv.lambda_handler"                  #Entry point (zip must contain the csv and lambda handler)
  runtime = "python3.11"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DDB_TABLE = aws_dynamodb_table.csv_table.name 
}
}
} 



############################################# Allow S3 to call the lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id = "AllowExecutionFromS3"
  action = "lambda:InvokeFunction"                                    #permission being granted
  function_name = aws_lambda_function.csv_processor.function_name 
 
  principal = "s3.amazonaws.com"                                      #Amazon s3 service is allowed to invoke                                      
  source_arn = aws_s3_bucket.csv_bucket.arn                           #Allow invovation from this s3 bucket  
}


##################################### Setup the actual S3-to-lambda trigger
resource "aws_s3_bucket_notification" "trigger" {
  bucket = aws_s3_bucket.csv_bucket.id                               #The S3 bucket to attach teh notification to

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_processor.arn 
    events = ["s3:ObjectCreated:*"]                                  #Trigger on any type of object created event 

    filter_suffix = ".csv" 
}
  depends_on = [aws_lambda_permission.allow_s3]                   #Ensures permission is granted before creating the trigger

}
