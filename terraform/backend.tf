terraform {
  backend "s3" {
    bucket = "my-tf-remote-state-bucket-15072025"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
  }
}
