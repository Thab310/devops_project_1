terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region  = "us-east-1"

  default_tags {
    tags = {
      environment = var.environment
      owner       = var.owner
      terraform   = true
      project     = var.project_name
    }
  }
}

locals {
  vpc_id           = aws_vpc.dev_vpc.id
  key_name         = "tp_key"
  pub_key_name     = "tp_key.pub"
  private_key_path = "~/.ssh/tp_key"
  public_key_path  = "~/.ssh/tp_key.pub"
  user             = "ubuntu"

}