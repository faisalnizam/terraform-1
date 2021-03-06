#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#

terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
  shared_credentials_file = pathexpand("/Users/captain/.aws/credentials")
}

module "key_pair" {
  source = "../../modules/key_pair"

  enable_key_pair = true
  key_name        = "test"
  public_key      = file("/Users/captain/.ssh/id_rsa.pub")

}
