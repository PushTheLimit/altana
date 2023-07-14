locals {
  resource_module     = "subnet"
  resource_name       = "${var.application}-${local.resource_module}"
  resource_identifier = var.identifier
}

resource "aws_subnet" "selected" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Env         = var.env
    Application = var.application
    Name        = "${local.resource_name}-${local.resource_identifier}"
    Terraform   = true
  }
}
