#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "~> 0.13.5"
}

provider "aws" {
  region                  = "us-west-2"
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}

module "s3" {
  source      = "../../modules/s3"
  name        = "TEST"
  environment = "NonPROD"

  enable_s3_bucket    = true
  s3_bucket_name      = "natarov-test-bucket"
  s3_bucket_acl       = "private"
  s3_bucket_cors_rule = []

  s3_bucket_versioning  = []
  enable_lifecycle_rule = true

  # Add policy to the bucket
  enable_s3_bucket_policy = false

  # Add files to bucket
  enable_s3_bucket_object = true
  s3_bucket_object_source = ["additional_files/test.txt", "additional_files/test2.txt"]
  type_of_file            = "txt"

  tags = map("Env", "stage", "Orchestration", "Terraform")

}
