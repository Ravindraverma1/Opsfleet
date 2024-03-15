terraform {
  required_version = ">= 1.7.0"
  backend "s3" {
    region         = "us-east-1"
    key            = "dev/core.tfstate"
    bucket         = "ravindra"
    dynamodb_table = "ravindra"
  }
}