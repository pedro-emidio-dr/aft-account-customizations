terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
   tags = {
     CreateBy = "Terraform"
     Module       = "Spoker"
   }
 }
}


