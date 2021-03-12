 terraform {
  backend "s3" {
    bucket         = "us-west-1-terraform-state-0258c3eeb1"
    dynamodb_table = "us-west-1-dynamodb_locking-0258c3eeb1"
    region         = "us-west-1"
    encrypt        = true
    key            = "global/terraform.tfstate"
  }
 }
