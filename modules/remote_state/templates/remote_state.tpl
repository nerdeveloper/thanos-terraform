 terraform {
  backend "s3" {
    bucket         = "${bucket_name}"
    dynamodb_table = "${dynamodb_table}"
    region         = "${region}"
    encrypt        = true
    key            = "global/terraform.tfstate"
  }
 }
