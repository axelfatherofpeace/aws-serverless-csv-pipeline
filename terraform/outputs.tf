output "s3_bucket_name" {
  description = "Name of the S3 bucket for CSV uploads"
  value       = aws_s3_bucket.csv_bucket.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table storing parsed CSV data"
  value       = aws_dynamodb_table.csv_table.name
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.csv_processor.function_name
}

output "lambda_role_name" {
  description = "IAM Role used by the Lambda function"
  value       = aws_iam_role.lambda_role.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic used for alerts"
  value       = aws_sns_topic.lambda_alerts.arn
}

output "sns_email_subscription" {
  description = "Email subscribed to SNS alerts"
  value       = aws_sns_topic_subscription.email_alert.endpoint
}

output "cloudwatch_alarm_name" {
  description = "Name of the CloudWatch alarm for Lambda errors"
  value       = aws_cloudwatch_metric_alarm.lambda_error_alarm.alarm_name
}
