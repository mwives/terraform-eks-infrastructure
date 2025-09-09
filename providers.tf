terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws   = ">= 6.11.0"
    local = ">= 2.5.3"
  }
}

provider "aws" {
  region = "us-east-1"
}
