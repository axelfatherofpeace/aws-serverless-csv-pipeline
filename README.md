########################################### AWS Serverless CSV Processing Pipeline

This project automates a serverless data ingestion and processing pipeline using AWS Lambda, S3, DynamoDB, SNS, and CloudWatch, all provisioned via Terraform and deployed with GitHub Actions.

Uploading a `.csv` file to an S3 bucket triggers a Lambda function that parses the file and stores the data in DynamoDB. Errors are monitored via CloudWatch and alert emails are sent using SNS.

## Features

- CSV Upload to S3
- Lambda parses and inserts rows into DynamoDB
- CloudWatch Alarm triggers on Lambda errors
- SNS Email Alerts for Lambda failures
- Infrastructure as Code with Terraform
- CI/CD using GitHub Actions

################################################## Project Structure

aws-serverless-csv-pipeline/
│
├── README.md                        # Project documentation
├── requirements.txt                # Placeholder if dependencies are needed
├── sample.csv                      # Sample CSV file for upload testing
├── lambda.zip                      # Zipped Lambda function for deployment
│
├── lambda/                         # Lambda source code
│   └── process_csv.py              # Python code to parse uploaded CSV
│
├── scripts/                        # Utility/test scripts
│   └── test_upload.sh              # Script to upload CSV to S3
│
├── terraform/                      # Terraform infrastructure definitions
│   ├── main.tf                     # All resource definitions (S3, Lambda, etc.)
│   ├── outputs.tf                  # Exports for key resource outputs
│   ├── backend.tf                  # Remote backend config (S3 + DynamoDB)
│   └── destroy.sh_disabled         # Optional destroy script (manual/disabled)
│
├── .github/
│   └── workflows/                  # GitHub Actions CI/CD pipelines
│       ├── ci.yml                  # Validates Terraform and Lambda code
│       ├── deploy.yml              # Zips Lambda, deploys infra via Terraform
│       └── destroy.yml_disabled    # (Optional) Terraform destroy workflow (manual)





################################################ Architecture
🛠️ Step-by-Step Implementation
1. Architecture Diagram

             ┌──────────────┐
             │  Developer   │
             │  (You)       │
             └────┬─────────┘
                  │
     ┌────────────▼────────────┐
     │ GitHub Actions CI/CD    │
     │ ─ ci.yml (validate)     │
     │ ─ deploy.yml (apply)    │
     └────────────┬────────────┘
                  │
     ┌────────────▼────────────┐
     │ Terraform               │
     │ ─ main.tf               │
     │ ─ backend.tf (S3 state) │
     └────────────┬────────────┘
                  │
        ┌─────────▼────────────┐
        │ AWS Infrastructure   │
        └─────────┬────────────┘
                  │
┌─────────────────▼────────────────────┐
│         S3 Bucket (CSV Upload)       │
│  - Triggers Lambda on .csv upload    │
└─────────────────┬────────────────────┘
                  │
        ┌─────────▼────────────┐
        │ AWS Lambda Function  │
        │ ─ Parses CSV         │
        │ ─ Writes to DynamoDB │
        │ ─ Logs to CloudWatch │
        └─────────┬────────────┘
                  │
      ┌───────────▼────────────┐
      │ DynamoDB Table          │
      │ ─ Stores parsed records │
      └────────────────────────┘

      ┌────────────────────────┐
      │ CloudWatch Logs        │
      │ ─ Lambda logs/errors   │
      └────┬───────────────────┘
           │
┌──────────▼────────────┐
│ CloudWatch Alarm       │
│ - Monitors Lambda errs │
└──────────┬────────────┘
           │
 ┌─────────▼─────────────┐
 │ SNS Topic             │
 │ ─ Email Notification  │
 │   on Alarm            │
 └───────────────────────┘


## Arcitecture Flow

Client uploads CSV to S3  
S3 triggers Lambda  
Lambda parses and inserts into DynamoDB  
CloudWatch monitors errors  
SNS sends email alert if Lambda fails

## Setup Instructions

### Prerequisites

- AWS CLI configured
- Terraform installed (v1.5.7)
- GitHub Secrets configured:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY

### Deployment using GitHub Actions

1. Run CI Validation  
   From GitHub UI → Actions → Run `CI Validate Infra and lambda Code` (ci.yml)

2. Run Terraform Deploy  
   From GitHub UI → Actions → Run `Deploy Infra and Lambda` (deploy.yml)

Lambda code is zipped automatically and deployed using Terraform.

### Destroy Infrastructure

To destroy resources, enable `destroy.yml` or run manually:

################################################################################################################

#bash scripts/test_upload.sh -- check the bucket name before executing this script uploads sample.csv 

This should:
- Trigger Lambda
- Parse CSV
- Insert records into DynamoDB
- Log events to CloudWatch


## SNS Email Alert

You will receive a confirmation email for subscription to the SNS topic.  
You must click "Confirm Subscription" to activate alerts.

## Notes

- backend.tf stores state in S3 with locking using DynamoDB
- lambda.zip must be present during Terraform apply (auto-zipped in workflow)
- destroy.yml is disabled by default to prevent accidental deletion

## Author

Ashish Kumar  
DevOps Engineer with expertise in Cloud Infrastructure and Automation


