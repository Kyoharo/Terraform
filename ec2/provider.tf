# this provides configuration to aws
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# provides the information to access aws specifically
provider "aws" {
  region = "us-west-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}