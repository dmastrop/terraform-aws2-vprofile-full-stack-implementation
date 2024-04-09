terraform {
    backend "s3" {
        bucket = "terraform-state-project16-vprofile"
        # this will create state in a folder called terraformstate/backend in the S3 bucket above
        key = "terraformstate/backend"
        region = "us-east-1"
    }
}