terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

# Configure the AWS Provider, default to us-east-1
provider "aws" {
  region = "us-east-1"
}

# Set up the variables to pass through to my custom kubernetes service
module "test_kubernetes_cluster_resources" {
  source = "../../services/kubernetes"

  env         = var.env
  application = "altana-codetest"
  vpc_cidr    = "10.0.0.0/16"

  nat_gateway_config = [
    {
      nat_subnet_identifier = "ac1",
      availability_zone     = "us-east-1a",
      subnet_cidr           = "10.0.1.0/24"
    },
    {
      nat_subnet_identifier = "ac2",
      availability_zone     = "us-east-1b",
      subnet_cidr           = "10.0.2.0/24"
    },
    {
      nat_subnet_identifier = "ac3",
      availability_zone     = "us-east-1c",
      subnet_cidr           = "10.0.3.0/24"
    }
  ]

  eks_cluster_config = {
    kubernetes_version      = "1.27"
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  eks_node_group_config = {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}
