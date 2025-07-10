output "s3_bucket_name" {
  value = aws_s3_bucket.csv_bucket.bucket
  description = "The name of the S3 bucket used for CSV upload"
}

