terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-project16-vprofile"
    # this will create state in a folder called terraformstate/backend in the S3 bucket above
    key    = "terraformstate/backend"
    region = "us-east-1"
  }
}