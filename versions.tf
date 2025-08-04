terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.7.0"

    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "AdministratorAccess-743065069150"
}
