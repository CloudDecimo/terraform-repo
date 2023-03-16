# terraform-repo
# for terraform testing activities

terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}

# Provider is AWS.
provider "aws" {
  region     = "us-east-1"
}