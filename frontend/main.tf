terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "svg-portfolio-tfstate"
    key = "frontend.tfstate"
    region = "eu-west-1"
    profile = "terraform"
  }
}

provider "aws" {
  region = "eu-west-1"
}