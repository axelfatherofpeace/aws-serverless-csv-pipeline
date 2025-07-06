# Event-Driven Serverless Data Pipeline

This project ingests `.csv` files using AWS S3, triggers a Lambda function to process and store the data in DynamoDB, and alerts via SNS if something goes wrong. All infrastructure is provisioned using Terraform and deployed via GitHub Actions.

## 📐 Architecture Diagram

            ┌────────────┐
Upload CSV ▶│    S3      │
            └────┬───────┘
                 │ triggers
            ┌────▼──────┐
            │  Lambda   │
            │(processes)│
            └────┬──────┘
                 │
          ┌──────▼────────┐
          │  DynamoDB     │ ← Stores processed data
          └───────────────┘
                 │
          ┌──────▼──────┐
          │ CloudWatch  │ ← Logs + Metrics
          └──────┬──────┘
                 ▼
              SNS Topic
               (Alerts)

## 🚀 Stack

- AWS Lambda (Python)
- AWS S3
- DynamoDB
- CloudWatch (Logs & Metrics)
- SNS (Alerts)
- Terraform
- GitHub Actions

