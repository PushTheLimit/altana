locals {
  resource_module = "vpc"
  resource_name   = "${var.application}-${local.resource_module}"
}

resource "aws_vpc" "selected" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = "default"


  tags = {
    Env         = var.env
    Application = var.application
    Name        = local.resource_name
    Terraform   = true
  }
}
