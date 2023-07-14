locals {
  resource_module = "internet_gateway"
  resource_name   = "${var.application}-${local.resource_module}"
}

resource "aws_internet_gateway" "selected" {
  vpc_id = var.vpc_id

  tags = {
    Env         = var.env
    Application = var.application
    Name        = local.resource_name
    Terraform   = true
  }
}
