terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws   = ">= 6.11.0"
    local = ">= 2.5.3"
  }
  backend "s3" {
    bucket = "mwives-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "new_vpc" {
  source         = "./modules/vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "eks" {
  source                    = "./modules/eks"
  prefix                    = var.prefix
  cluster_name              = var.cluster_name
  retention_in_days         = var.retention_in_days
  aws_vpc_id                = module.new_vpc.aws_vpc_id
  aws_subnet_ids            = module.new_vpc.aws_subnet_ids
  eks_node_desired_capacity = var.eks_node_desired_capacity
  eks_node_min_size         = var.eks_node_min_size
  eks_node_max_size         = var.eks_node_max_size
}
